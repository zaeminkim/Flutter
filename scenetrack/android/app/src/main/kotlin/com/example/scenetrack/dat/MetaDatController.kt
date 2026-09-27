package com.example.scenetrack.dat

import android.Manifest
import android.content.pm.PackageManager
import android.os.Build
import androidx.core.content.ContextCompat
import androidx.fragment.app.FragmentActivity
import com.meta.wearable.dat.core.Wearables
import com.meta.wearable.dat.core.selectors.AutoDeviceSelector
import com.meta.wearable.dat.core.types.PermissionStatus
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
    private val deviceSelector = AutoDeviceSelector()

    private var eventSink: EventChannel.EventSink? = null
    private var registrationJob: Job? = null
    private var deviceJob: Job? = null
    private var registrationErrorJob: Job? = null

    fun attachEventSink(sink: EventChannel.EventSink) {
        eventSink = sink
        startMonitoring()
    }

    fun detachEventSink() {
        eventSink = null
        stopMonitoring()
    }

    fun startRegistration() {
        if (
            Build.VERSION.SDK_INT >= Build.VERSION_CODES.S &&
            ContextCompat.checkSelfPermission(
                activity,
                Manifest.permission.BLUETOOTH_CONNECT,
            ) != PackageManager.PERMISSION_GRANTED
        ) {
            requestBluetoothPermission()
            return
        }

        startRegistrationAfterAndroidPermission()
    }

    fun onBluetoothPermissionResult(granted: Boolean) {
        if (granted) {
            startRegistrationAfterAndroidPermission()
        } else {
            reportError("스마트 글래스 연결을 위해 Bluetooth 권한이 필요합니다.")
        }
    }

    private fun startRegistrationAfterAndroidPermission() {
        try {
            Wearables.startRegistration(activity)
        } catch (error: Throwable) {
            reportError(
                error.message ?: "Meta AI 등록 화면을 열지 못했습니다.",
            )
        }
    }

    fun startUnregistration() {
        try {
            Wearables.startUnregistration(activity)
        } catch (error: Throwable) {
            reportError(
                error.message ?: "등록 해제를 시작하지 못했습니다.",
            )
        }
    }

    fun requestDatCameraPermission() {
        requestCameraPermission()
    }

    fun onCameraPermissionResult(status: PermissionStatus) {
        val permissionState = when (status) {
            PermissionStatus.Granted -> "GRANTED"
            PermissionStatus.Denied -> "DENIED"
        }

        sendEvent(
            mapOf(
                "type" to "CAMERA_PERMISSION",
                "granted" to (status == PermissionStatus.Granted),
                "state" to permissionState,
            ),
        )
    }

    fun reportError(message: String) {
        sendEvent(
            mapOf(
                "type" to "error",
                "message" to message,
            )
        )
    }

    private fun startMonitoring() {
        stopMonitoring()

        registrationJob = scope.launch {
            Wearables.registrationState.collect { state ->
                sendEvent(
                    mapOf(
                        "type" to "registration",
                        "state" to state.name,
                    )
                )
            }
        }

        deviceJob = scope.launch {
            deviceSelector.activeDeviceFlow().collect { device ->
                sendEvent(
                    mapOf(
                        "type" to "device",
                        "hasActiveDevice" to (device != null),
                        "deviceId" to device?.toString(),
                    )
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

    fun dispose() {
        stopMonitoring()
        eventSink = null
    }
}
