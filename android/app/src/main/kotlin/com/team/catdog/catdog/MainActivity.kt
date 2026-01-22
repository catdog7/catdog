package com.team.catdog.catdog

import android.app.NotificationChannel
import android.app.NotificationManager
import android.os.Build
import android.os.Bundle
import android.content.Intent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private var initialUri: String? = null
    private val CHANNEL = "com.team.catdog/widget"

    override fun onNewIntent(intent: Intent) {
        val uri = intent.dataString
        android.util.Log.d("MainActivity", "onNewIntent: $uri")

        // catdog-widget 스킴은 Flutter Navigator가 아닌 MethodChannel로만 처리 (중복 네비게이션 방지)
        if (uri != null && uri.startsWith("catdog-widget://")) {
            setIntent(intent) // Intent 갱신
            flutterEngine?.dartExecutor?.binaryMessenger?.let {
                MethodChannel(it, CHANNEL).invokeMethod("onDeepLink", uri)
            }
            return // super.onNewIntent 호출 생략하여 Flutter가 라우트로 인식하지 않게 함
        }

        super.onNewIntent(intent)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "getInitialUri" -> {
                    android.util.Log.d("MainActivity", "getInitialUri requested. Current initialUri: $initialUri")
                    result.success(initialUri)
                    initialUri = null // Reset after consumption
                }
                else -> result.notImplemented()
            }
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        initialUri = intent?.dataString


        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                "default_channel",        // AndroidManifest에 쓴 ID
                "친구 알림",              // 설정 화면에 보이는 이름
                NotificationManager.IMPORTANCE_HIGH
            )

            val manager = getSystemService(NotificationManager::class.java)
            manager.createNotificationChannel(channel)
        }
    }
}
