package com.serasa.pokedex.analytics

import android.os.Bundle
import com.google.firebase.analytics.FirebaseAnalytics
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class AnalyticsMethodChannel(
    private val firebaseAnalytics: FirebaseAnalytics
) : MethodChannel.MethodCallHandler {

    companion object {
        private const val CHANNEL_NAME = "com.serasa.pokedex/analytics"
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "logEvent" -> {
                val eventName = call.argument<String>("eventName")
                val parameters = call.argument<Map<String, Any>>("parameters")

                if (eventName != null && parameters != null) {
                    logEvent(eventName, parameters)
                    result.success(null)
                } else {
                    result.error("INVALID_ARGUMENT", "Missing parameters", null)
                }
            }

            "logScreenView" -> {
                val screenName = call.argument<String>("screenName")
                val screenClass = call.argument<String>("screenClass")

                if (screenName != null && screenClass != null) {
                    logScreenView(screenName, screenClass)
                    result.success(null)
                } else {
                    result.error("INVALID_ARGUMENT", "Missing parameters", null)
                }
            }

            else -> result.notImplemented()
        }
    }

    private fun logEvent(eventName: String, parameters: Map<String, Any>) {
        val bundle = Bundle().apply {
            parameters.forEach { (key, value) ->
                when (value) {
                    is String -> putString(key, value)
                    is Int -> putInt(key, value)
                    is Long -> putLong(key, value)
                    is Double -> putDouble(key, value)
                    is Boolean -> putBoolean(key, value)
                }
            }
        }
        firebaseAnalytics.logEvent(eventName, bundle)
    }

    private fun logScreenView(screenName: String, screenClass: String) {
        val bundle = Bundle().apply {
            putString(FirebaseAnalytics.Param.SCREEN_NAME, screenName)
            putString(FirebaseAnalytics.Param.SCREEN_CLASS, screenClass)
        }
        firebaseAnalytics.logEvent(FirebaseAnalytics.Event.SCREEN_VIEW, bundle)
    }
}