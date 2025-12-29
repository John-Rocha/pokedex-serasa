package com.serasa.pokedex.pokedex_serasa

import com.google.firebase.analytics.FirebaseAnalytics
import com.serasa.pokedex.analytics.AnalyticsMethodChannel
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        val analytics = FirebaseAnalytics.getInstance(this)
        val analyticsChannel = AnalyticsMethodChannel(analytics)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "com.serasa.pokedex/analytics"
        ).setMethodCallHandler(analyticsChannel)
    }
}