package com.example.sync_app

import android.Manifest
import android.content.pm.PackageManager
import androidx.activity.result.contract.ActivityResultContracts
import androidx.core.content.ContextCompat
import androidx.lifecycle.lifecycleScope
import com.example.sync_app.dat.MetaDatChannels
import com.example.sync_app.dat.MetaDatController
import com.meta.wearable.dat.core.Wearables
import com.meta.wearable.dat.core.types.Permission
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterFragmentActivity() {

    private lateinit var datController: MetaDatController
    private lateinit var datChannels: MetaDatChannels

    private val bluetoothPermissionLauncher =
        registerForActivityResult(
            ActivityResultContracts.RequestPermission()
        ) { granted ->
            if (::datController.isInitialized) {
                datController.onBluetoothPermissionResult(granted)
            }
        }

    private val datCameraPermissionLauncher =
        registerForActivityResult(
            Wearables.RequestPermissionContract()
        ) { result ->
            if (!::datController.isInitialized) {
                return@registerForActivityResult
            }

            result
                .onSuccess { status ->
                    datController.onCameraPermissionResult(status)
                }
                .onFailure { error, _ ->
                    datController.reportError(error.description)
                }
        }

    private val androidCameraPermissionLauncher =
        registerForActivityResult(
            ActivityResultContracts.RequestPermission()
        ) { granted ->
            if (!::datController.isInitialized) {
                return@registerForActivityResult
            }

            if (granted) {
                datCameraPermissionLauncher.launch(Permission.CAMERA)
            } else {
                datController.reportError(
                    "카메라 기능을 사용하려면 Android 카메라 권한이 필요합니다."
                )
            }
        }

    override fun configureFlutterEngine(
        flutterEngine: FlutterEngine,
    ) {
        super.configureFlutterEngine(flutterEngine)

        datController = MetaDatController(
            activity = this,
            scope = lifecycleScope,
            textureRegistry = flutterEngine.renderer,
            requestBluetoothPermission = {
                bluetoothPermissionLauncher.launch(
                    Manifest.permission.BLUETOOTH_CONNECT
                )
            },
            requestCameraPermission = ::requestCameraPermissions,
        )

        datChannels = MetaDatChannels(
            messenger = flutterEngine.dartExecutor.binaryMessenger,
            controller = datController,
        )

        datChannels.register()
    }

    override fun onDestroy() {
        if (::datChannels.isInitialized) {
            datChannels.dispose()
        }

        super.onDestroy()
    }

    private fun requestCameraPermissions() {
        val hasAndroidCameraPermission =
            ContextCompat.checkSelfPermission(
                this,
                Manifest.permission.CAMERA,
            ) == PackageManager.PERMISSION_GRANTED

        if (hasAndroidCameraPermission) {
            datCameraPermissionLauncher.launch(Permission.CAMERA)
        } else {
            androidCameraPermissionLauncher.launch(
                Manifest.permission.CAMERA
            )
        }
    }
}
