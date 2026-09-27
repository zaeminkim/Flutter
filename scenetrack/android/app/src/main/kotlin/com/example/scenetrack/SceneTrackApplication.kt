package com.example.scenetrack

import android.app.Application
import android.util.Log
import com.meta.wearable.dat.core.Wearables

class SceneTrackApplication : Application() {

    override fun onCreate() {
        super.onCreate()

        Wearables.initialize(this)
            .onFailure { error, _ ->
                Log.e(
                    "SceneTrackDAT",
                    "DAT initialization failed: ${error.description}",
                )
            }
    }
}