package com.example.scenetrack

import android.Manifest
import androidx.activity.result.contract.ActivityResultContracts
import androidx.lifecycle.lifecycleScope
import com.example.scenetrack.dat.MetaDatChannels
import com.example.scenetrack.dat.MetaDatController
import com.meta.wearable.dat.core.Wearables
import com.meta.wearable.dat.core.types.Permission
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import android.content.pm.PackageManager
import androidx.core.content.ContextCompat

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

    private val cameraPermissionLauncher =
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

    override fun configureFlutterEngine(
        flutterEngine: FlutterEngine,
    ) {
        super.configureFlutterEngine(flutterEngine)

        datController = MetaDatController(
            activity = this,
            scope = lifecycleScope,
            requestBluetoothPermission = {
                bluetoothPermissionLauncher.launch(
                    Manifest.permission.BLUETOOTH_CONNECT
                )
            },
            requestCameraPermission = {
                cameraPermissionLauncher.launch(
                    Permission.CAMERA
                )
            },
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
}