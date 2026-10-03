package com.example.sync_app.dat

import android.Manifest
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.content.pm.PackageManager
import android.os.Build
import androidx.core.content.ContextCompat
import androidx.fragment.app.FragmentActivity
import com.example.sync_app.dat.camera.FlutterCameraTexture
import com.example.sync_app.dat.camera.YuvToBitmapConverter
import com.meta.wearable.dat.camera.Camera
import com.meta.wearable.dat.camera.addCamera
import com.meta.wearable.dat.camera.types.PhotoData
import com.meta.wearable.dat.camera.types.StreamConfiguration
import com.meta.wearable.dat.camera.types.StreamState
import com.meta.wearable.dat.camera.types.VideoQuality
import com.meta.wearable.dat.core.Wearables
import com.meta.wearable.dat.core.selectors.AutoDeviceSelector
import com.meta.wearable.dat.core.session.DeviceSession
import com.meta.wearable.dat.core.session.DeviceSessionState
import com.meta.wearable.dat.core.types.Permission
import com.meta.wearable.dat.core.types.PermissionStatus
import com.meta.wearable.dat.core.types.RegistrationState
import com.meta.wearable.dat.inputs.Inputs
import com.meta.wearable.dat.inputs.addInputs
import com.meta.wearable.dat.inputs.removeInputs
import com.meta.wearable.dat.inputs.types.CapturePressType
import com.meta.wearable.dat.inputs.types.InputEvent
import com.meta.wearable.dat.inputs.types.InputSource
import com.meta.wearable.dat.inputs.types.InputsConfiguration
import io.flutter.plugin.common.EventChannel
import io.flutter.view.TextureRegistry
import java.io.File
import java.io.FileOutputStream
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.Job
import kotlinx.coroutines.flow.conflate
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext

class MetaDatController(
    private val activity: FragmentActivity,
    private val scope: CoroutineScope,
    private val textureRegistry: TextureRegistry,
    private val requestBluetoothPermission: () -> Unit,
    private val requestCameraPermission: () -> Unit,
) {
    private val deviceSelector by lazy { AutoDeviceSelector() }

    private var eventSink: EventChannel.EventSink? = null
    private var registrationJob: Job? = null
    private var deviceJob: Job? = null
    private var registrationErrorJob: Job? = null
    private var cameraSession: DeviceSession? = null
    private var camera: Camera? = null
    private var sessionStateJob: Job? = null
    private var sessionErrorJob: Job? = null
    private var streamStateJob: Job? = null
    private var streamErrorJob: Job? = null
    private var videoFrameJob: Job? = null
    private var previewTexture: FlutterCameraTexture? = null
    private var inputs: Inputs? = null
    private var inputsEventJob: Job? = null
    private var inputsErrorJob: Job? = null
    private var isAttachingCamera = false
    private var isAttachingInputs = false
    private var isCapturing = false
    private var isDatInitialized = false

    fun attachEventSink(sink: EventChannel.EventSink) {
        eventSink = sink

        if (hasBluetoothPermission()) {
            initializeDat { startMonitoring() }
        }
    }

    fun detachEventSink() {
        eventSink = null
        stopMonitoring()
    }

    fun startRegistration() {
        if (!hasBluetoothPermission()) {
            requestBluetoothPermission()
            return
        }

        initializeDat {
            startMonitoring()
            startRegistrationIfNeeded()
        }
    }

    fun onBluetoothPermissionResult(granted: Boolean) {
        if (!granted) {
            reportError("스마트글래스 연결을 위해 Bluetooth 권한이 필요합니다.")
            return
        }

        initializeDat {
            startMonitoring()
            startRegistrationIfNeeded()
        }
    }

    fun startUnregistration() {
        if (!hasBluetoothPermission()) {
            reportError("스마트글래스 연결을 해제하려면 Bluetooth 권한이 필요합니다.")
            return
        }

        initializeDat {
            try {
                Wearables.startUnregistration(activity)
            } catch (error: Throwable) {
                reportError(error.message ?: "등록 해제를 시작하지 못했습니다.")
            }
        }
    }

    fun requestDatCameraPermission() {
        if (!isDatInitialized) {
            reportError("먼저 스마트글래스를 연결해 주세요.")
            return
        }

        scope.launch {
            Wearables.checkPermissionStatus(Permission.CAMERA)
                .onSuccess { status ->
                    if (status == PermissionStatus.Granted) {
                        onCameraPermissionResult(status)
                    } else {
                        requestCameraPermission()
                    }
                }
                .onFailure { error, _ ->
                    reportError("카메라 권한 상태 확인 실패: ${error.description}")
                }
        }
    }

    fun onCameraPermissionResult(
        status: PermissionStatus,
        isSnapshot: Boolean = false,
        message: String? = null,
    ) {
        sendEvent(
            mapOf(
                "type" to "CAMERA_PERMISSION",
                "granted" to (status == PermissionStatus.Granted),
                "state" to if (status == PermissionStatus.Granted) "GRANTED" else "DENIED",
                "isSnapshot" to isSnapshot,
                "message" to message,
            ),
        )
    }

    fun startCameraSession() {
        if (!isDatInitialized) {
            reportError("먼저 스마트글래스를 연결해 주세요.")
            return
        }

        if (Wearables.registrationState.value != RegistrationState.REGISTERED) {
            reportError("스마트글래스 등록이 완료되지 않았습니다.")
            return
        }

        if (cameraSession != null) {
            return
        }

        Wearables.createSession(deviceSelector)
            .onSuccess { createdSession ->
                cameraSession = createdSession

                sessionStateJob = scope.launch {
                    createdSession.state.collect { state ->
                        sendEvent(
                            mapOf(
                                "type" to "cameraSession",
                                "state" to state.name,
                            ),
                        )

                        if (state == DeviceSessionState.STARTED) {
                            attachCamera(createdSession)
                            attachInputs(createdSession)
                        }
                    }
                }

                sessionErrorJob = scope.launch {
                    createdSession.errors.collect { error ->
                        reportError("기기 세션 오류: ${error.description}")
                    }
                }

                createdSession.start()
            }
            .onFailure { error, _ ->
                reportError("기기 세션 생성 실패: ${error.description}")
            }
    }

    fun capturePhoto(source: String = "app") {
        if (isCapturing) {
            return
        }

        val activeStream = camera?.stream

        if (activeStream == null) {
            reportError("카메라가 준비되지 않았습니다.")
            return
        }

        if (activeStream.state.value != StreamState.STREAMING) {
            reportError("카메라 스트리밍이 아직 준비되지 않았습니다.")
            return
        }

        isCapturing = true
        sendCaptureEvent(state = "CAPTURING", source = source)

        scope.launch {
            activeStream.capturePhoto()
                .onSuccess { photoData ->
                    try {
                        val photoFile = savePhoto(photoData)
                        sendCaptureEvent(
                            state = "COMPLETED",
                            source = source,
                            path = photoFile.absolutePath,
                        )
                    } catch (error: Throwable) {
                        sendCaptureEvent(
                            state = "FAILED",
                            source = source,
                            message = error.message ?: "촬영한 사진을 저장하지 못했습니다.",
                        )
                    } finally {
                        isCapturing = false
                    }
                }
                .onFailure { error, _ ->
                    isCapturing = false
                    sendCaptureEvent(
                        state = "FAILED",
                        source = source,
                        message = error.description,
                    )
                }
        }
    }

    fun stopCameraSession() {
        inputsEventJob?.cancel()
        inputsEventJob = null
        inputsErrorJob?.cancel()
        inputsErrorJob = null
        videoFrameJob?.cancel()
        videoFrameJob = null
        streamStateJob?.cancel()
        streamStateJob = null
        streamErrorJob?.cancel()
        streamErrorJob = null
        sessionStateJob?.cancel()
        sessionStateJob = null
        sessionErrorJob?.cancel()
        sessionErrorJob = null

        val activeSession = cameraSession

        if (inputs != null && activeSession != null) {
            activeSession.removeInputs()
        }
        inputs = null

        camera?.stop()
        camera = null
        activeSession?.stop()
        cameraSession = null

        previewTexture?.release()
        previewTexture = null

        isAttachingCamera = false
        isAttachingInputs = false
        isCapturing = false
    }

    fun reportError(message: String) {
        sendEvent(
            mapOf(
                "type" to "error",
                "message" to message,
            ),
        )
    }

    fun dispose() {
        stopCameraSession()
        stopMonitoring()
        eventSink = null
    }

    private fun attachCamera(activeSession: DeviceSession) {
        if (camera != null || isAttachingCamera) {
            return
        }

        isAttachingCamera = true

        activeSession.addCamera(
            StreamConfiguration(
                videoQuality = VideoQuality.MEDIUM,
                frameRate = 15,
                compressVideo = false,
            ),
        ).onSuccess { addedCamera ->
            camera = addedCamera
            isAttachingCamera = false
            previewTexture = FlutterCameraTexture(textureRegistry)

            streamStateJob = scope.launch {
                addedCamera.stream.state.collect { state ->
                    sendEvent(
                        mapOf(
                            "type" to "camera",
                            "state" to state.name,
                            "ready" to (state == StreamState.STREAMING),
                            "textureId" to previewTexture?.textureId,
                            "width" to 504,
                            "height" to 896,
                        ),
                    )
                }
            }

            streamErrorJob = scope.launch {
                addedCamera.stream.errorStream.collect { error ->
                    reportError("카메라 스트림 오류: ${error.description}")
                }
            }

            videoFrameJob = scope.launch {
                addedCamera.stream.videoStream
                    .conflate()
                    .collect { frame ->
                        if (frame.isCompressed || frame.isCodecConfig) {
                            return@collect
                        }

                        val bitmap = withContext(Dispatchers.Default) {
                            YuvToBitmapConverter.convert(
                                yuvData = frame.buffer,
                                width = frame.width,
                                height = frame.height,
                            )
                        }

                        if (bitmap != null) {
                            previewTexture?.render(bitmap)
                        }
                    }
            }

            addedCamera.stream.start()
                .onFailure { error, _ ->
                    reportError("카메라 스트림 시작 실패: ${error.description}")
                }
        }.onFailure { error, _ ->
            isAttachingCamera = false
            reportError("카메라 연결 실패: ${error.description}")
        }
    }

    private fun attachInputs(activeSession: DeviceSession) {
        if (inputs != null || isAttachingInputs) {
            return
        }

        isAttachingInputs = true

        activeSession.addInputs(
            InputsConfiguration(
                sources = setOf(InputSource.CAPTURE_BUTTON),
                consumeBack = false,
            ),
        ).onSuccess { addedInputs ->
            inputs = addedInputs
            isAttachingInputs = false

            inputsEventJob = scope.launch {
                addedInputs.events.collect { event ->
                    if (
                        event is InputEvent.Capture &&
                        event.source == InputSource.CAPTURE_BUTTON &&
                        event.pressType == CapturePressType.SHORT_PRESS
                    ) {
                        capturePhoto(source = "glasses")
                    }
                }
            }

            inputsErrorJob = scope.launch {
                addedInputs.errors.collect { error ->
                    if (error != null) {
                        reportError("스마트글래스 입력 오류: ${error.description}")
                    }
                }
            }
        }.onFailure { error, _ ->
            isAttachingInputs = false
            reportError(
                "스마트글래스 카메라 버튼을 연결하지 못했습니다: ${error.description}",
            )
        }
    }

    private fun savePhoto(photoData: PhotoData): File {
        val bitmap = when (photoData) {
            is PhotoData.Bitmap -> photoData.bitmap
            is PhotoData.HEIC -> {
                val buffer = photoData.data.duplicate()
                val bytes = ByteArray(buffer.remaining())
                buffer.get(bytes)

                BitmapFactory.decodeByteArray(bytes, 0, bytes.size)
                    ?: throw IllegalStateException("HEIC 사진을 변환하지 못했습니다.")
            }
        }

        return saveBitmapAsJpeg(bitmap)
    }

    private fun saveBitmapAsJpeg(bitmap: Bitmap): File {
        val photoDirectory = File(activity.cacheDir, "captured_photos").apply {
            mkdirs()
        }
        val photoFile = File(
            photoDirectory,
            "sync_${System.currentTimeMillis()}.jpg",
        )

        FileOutputStream(photoFile).use { output ->
            val saved = bitmap.compress(Bitmap.CompressFormat.JPEG, 95, output)
            if (!saved) {
                throw IllegalStateException("사진 파일을 저장하지 못했습니다.")
            }
        }

        return photoFile
    }

    private fun sendCaptureEvent(
        state: String,
        source: String,
        path: String? = null,
        message: String? = null,
    ) {
        sendEvent(
            mapOf(
                "type" to "capture",
                "state" to state,
                "source" to source,
                "path" to path,
                "message" to message,
            ),
        )
    }

    private fun hasBluetoothPermission(): Boolean {
        return Build.VERSION.SDK_INT < Build.VERSION_CODES.S ||
            ContextCompat.checkSelfPermission(
                activity,
                Manifest.permission.BLUETOOTH_CONNECT,
            ) == PackageManager.PERMISSION_GRANTED
    }

    private fun initializeDat(onReady: () -> Unit) {
        if (isDatInitialized) {
            onReady()
            return
        }

        Wearables.initialize(activity.applicationContext)
            .onSuccess {
                isDatInitialized = true
                onReady()
            }
            .onFailure { error, _ ->
                reportError("Meta DAT 초기화 실패: ${error.description}")
            }
    }

    private fun startRegistrationIfNeeded() {
        when (Wearables.registrationState.value) {
            RegistrationState.REGISTERED,
            RegistrationState.REGISTERING -> Unit

            else -> {
                try {
                    Wearables.startRegistration(activity)
                } catch (error: Throwable) {
                    reportError(error.message ?: "Meta AI 등록 화면을 열지 못했습니다.")
                }
            }
        }
    }

    private fun refreshCameraPermissionStatus() {
        scope.launch {
            Wearables.checkPermissionStatus(Permission.CAMERA)
                .onSuccess { status ->
                    onCameraPermissionResult(
                        status = status,
                        isSnapshot = true,
                    )
                }
                .onFailure { error, _ ->
                    onCameraPermissionResult(
                        status = PermissionStatus.Denied,
                        isSnapshot = true,
                        message = "카메라 권한 상태 확인 실패: ${error.description}",
                    )
                }
        }
    }

    private fun startMonitoring() {
        stopMonitoring()

        registrationJob = scope.launch {
            Wearables.registrationState.collect { state ->
                sendEvent(
                    mapOf(
                        "type" to "registration",
                        "state" to state.name,
                    ),
                )

                if (state == RegistrationState.REGISTERED) {
                    refreshCameraPermissionStatus()
                }
            }
        }

        deviceJob = scope.launch {
            deviceSelector.activeDeviceFlow().collect { device ->
                sendEvent(
                    mapOf(
                        "type" to "device",
                        "hasActiveDevice" to (device != null),
                        "deviceId" to device?.toString(),
                    ),
                )
            }
        }

        registrationErrorJob = scope.launch {
            Wearables.registrationErrorStream.collect { error ->
                reportError(error.description)
            }
        }
    }

    private fun stopMonitoring() {
        registrationJob?.cancel()
        registrationJob = null
        deviceJob?.cancel()
        deviceJob = null
        registrationErrorJob?.cancel()
        registrationErrorJob = null
    }

    private fun sendEvent(event: Map<String, Any?>) {
        activity.runOnUiThread {
            eventSink?.success(event)
        }
    }
}
