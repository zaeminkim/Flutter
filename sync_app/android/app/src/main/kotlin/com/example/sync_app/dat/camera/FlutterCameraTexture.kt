package com.example.sync_app.dat.camera

import android.graphics.Bitmap
import android.graphics.Color
import android.graphics.Paint
import android.graphics.Rect
import io.flutter.view.TextureRegistry

internal class FlutterCameraTexture(
    textureRegistry: TextureRegistry,
) {
    private val surfaceProducer = textureRegistry.createSurfaceProducer()
    private val paint = Paint(Paint.ANTI_ALIAS_FLAG or Paint.FILTER_BITMAP_FLAG)
    private val destinationRect = Rect()

    private var currentWidth = 0
    private var currentHeight = 0
    private var isReleased = false

    val textureId: Long
        get() = surfaceProducer.id()

    @Synchronized
    fun render(bitmap: Bitmap) {
        if (isReleased) {
            return
        }

        updateSizeIfNeeded(
            width = bitmap.width,
            height = bitmap.height,
        )

        val surface = try {
            surfaceProducer.surface
        } catch (_: Throwable) {
            return
        }

        if (!surface.isValid) {
            return
        }

        val canvas = try {
            surface.lockCanvas(null)
        } catch (_: Throwable) {
            return
        }

        try {
            canvas.drawColor(Color.BLACK)
            destinationRect.set(0, 0, canvas.width, canvas.height)
            canvas.drawBitmap(bitmap, null, destinationRect, paint)
        } finally {
            try {
                surface.unlockCanvasAndPost(canvas)
            } catch (_: Throwable) {
                return
            }
        }

        surfaceProducer.scheduleFrame()
    }

    @Synchronized
    fun release() {
        if (isReleased) {
            return
        }

        isReleased = true
        surfaceProducer.release()
    }

    private fun updateSizeIfNeeded(
        width: Int,
        height: Int,
    ) {
        if (currentWidth == width && currentHeight == height) {
            return
        }

        currentWidth = width
        currentHeight = height
        surfaceProducer.setSize(width, height)
    }
}
