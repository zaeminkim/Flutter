package com.example.scenetrack.dat

import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class MetaDatChannels(
    messenger: BinaryMessenger,
    private val controller: MetaDatController,
) : MethodChannel.MethodCallHandler, EventChannel.StreamHandler {

    companion object {
        private const val METHOD_CHANNEL =
            "com.scenetrack/meta_dat/methods"

        private const val EVENT_CHANNEL =
            "com.scenetrack/meta_dat/events"
    }

    private val methodChannel =
        MethodChannel(messenger, METHOD_CHANNEL)

    private val eventChannel =
        EventChannel(messenger, EVENT_CHANNEL)

    fun register() {
        methodChannel.setMethodCallHandler(this)
        eventChannel.setStreamHandler(this)
    }

    override fun onMethodCall(
        call: MethodCall,
        result: MethodChannel.Result,
    ) {
        when (call.method) {
            "startRegistration" -> {
                controller.startRegistration()
                result.success(null)
            }

            "startUnregistration" -> {
                controller.startUnregistration()
                result.success(null)
            }

            "requestCameraPermission" -> {
                controller.requestDatCameraPermission()
                result.success(null)
            }

            "startStream" -> {
                result.error(
                    "NOT_IMPLEMENTED",
                    "카메라 스트리밍 계층은 아직 구현되지 않았습니다.",
                    null,
                )
            }

            "stopStream" -> {
                result.error(
                    "NOT_IMPLEMENTED",
                    "카메라 스트리밍 계층은 아직 구현되지 않았습니다.",
                    null,
                )
            }

            else -> result.notImplemented()
        }
    }

    override fun onListen(
        arguments: Any?,
        events: EventChannel.EventSink?,
    ) {
        if (events != null) {
            controller.attachEventSink(events)
        }
    }

    override fun onCancel(arguments: Any?) {
        controller.detachEventSink()
    }

    fun dispose() {
        methodChannel.setMethodCallHandler(null)
        eventChannel.setStreamHandler(null)
        controller.dispose()
    }
}