package com.team.catdog.catdog

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.net.Uri
import android.os.Handler
import android.os.Looper
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetProvider
import java.net.URL
import java.util.concurrent.Executors

class FrameWidgetProvider : HomeWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        for (appWidgetId in appWidgetIds) {
            updateWidget(context, appWidgetManager, appWidgetId, widgetData)
        }
    }

    private fun updateWidget(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetId: Int,
        widgetData: SharedPreferences
    ) {
        val views = RemoteViews(context.packageName, R.layout.frame_widget_layout)

        // Intent to open the app when widget is clicked
        val intent = Intent(Intent.ACTION_VIEW, Uri.parse("catdog-widget://frame"))
        intent.setPackage(context.packageName)
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)

        val pendingIntent = PendingIntent.getActivity(
            context,
            appWidgetId,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        views.setOnClickPendingIntent(R.id.frame_image, pendingIntent)

        // Get saved image URL from home_widget SharedPreferences
        val imageUrl = widgetData.getString("latest_image_url", null)

        if (imageUrl != null && imageUrl.isNotEmpty()) {
            // Load image from URL in background thread
            loadImageFromUrl(context, appWidgetManager, appWidgetId, views, imageUrl)
        } else {
            // Show default image
            views.setImageViewResource(R.id.frame_image, R.drawable.ic_frame_default)
            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }

    companion object {
        private val executor = Executors.newCachedThreadPool()
    }

    private fun loadImageFromUrl(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetId: Int,
        views: RemoteViews,
        imageUrl: String
    ) {
        val handler = Handler(Looper.getMainLooper())

        executor.execute {
            try {
                val url = URL(imageUrl)
                val originalBitmap = BitmapFactory.decodeStream(url.openConnection().getInputStream())
                
                handler.post {
                    if (originalBitmap != null) {
                        // Crop to square (1:1 aspect ratio)
                        val squareBitmap = cropToSquare(originalBitmap)
                        views.setImageViewBitmap(R.id.frame_image, squareBitmap)
                        appWidgetManager.updateAppWidget(appWidgetId, views)
                        
                        // Recycle original bitmap to free memory
                        if (!originalBitmap.isRecycled && originalBitmap != squareBitmap) {
                            originalBitmap.recycle()
                        }
                    } else {
                        views.setImageViewResource(R.id.frame_image, R.drawable.ic_frame_default)
                        appWidgetManager.updateAppWidget(appWidgetId, views)
                    }
                }
            } catch (e: Exception) {
                handler.post {
                    views.setImageViewResource(R.id.frame_image, R.drawable.ic_frame_default)
                    appWidgetManager.updateAppWidget(appWidgetId, views)
                }
            }
        }
    }

    private fun cropToSquare(bitmap: Bitmap): Bitmap {
        val width = bitmap.width
        val height = bitmap.height
        val size = minOf(width, height)
        val x = (width - size) / 2
        val y = (height - size) / 2
        return Bitmap.createBitmap(bitmap, x, y, size, size)
    }
}
