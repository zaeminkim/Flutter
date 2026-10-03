package com.example.sync_app.dat

import android.Manifest
import android.content.pm.PackageManager
import android.os.Build
import androidx.core.content.ContextCompat
import androidx.fragment.app.FragmentActivity
import com.meta.wearable.dat.core.Wearables
import com.meta.wearable.dat.core.selectors.AutoDeviceSelector
import com.meta.wearable.dat.core.types.Permission
import com.meta.wearable.dat.core.types.PermissionStatus
import com.meta.wearable.dat.core.types.RegistrationState
import io.flutter.plugin.common.EventChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Job
import kotlinx.coroutines.launch

class MetaDatController(
    private val activity: FragmentActivity,
    private val scope: CoroutineScope,
    private val requestBluetoothPermission: () -> Unit,
    private val requestCameraPermission: () -> Unit,
) {
    private val deviceSelector by lazy { AutoDeviceSelector() }

    private var eventSink: EventChannel.EventSink? = null
    private var registrationJob: Job? = null
    private var deviceJob: Job? = null
    private var registrationErrorJob: Job? = null
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

    fun reportError(message: String) {
        sendEvent(
            mapOf(
                "type" to "error",
                "message" to message,
            ),
        )
    }

    fun dispose() {
        stopMonitoring()
        eventSink = null
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
