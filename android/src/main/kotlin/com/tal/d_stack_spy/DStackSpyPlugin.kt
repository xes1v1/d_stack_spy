package com.tal.d_stack_spy

import android.app.Activity
import android.app.Application
import android.app.Application.ActivityLifecycleCallbacks
import android.os.Bundle
import android.text.TextUtils
import android.util.Log
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.util.*

/** DStackSpyPlugin */
class DStackSpyPlugin : FlutterPlugin, MethodCallHandler {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private lateinit var activity: Activity

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "d_stack_spy")
        channel.setMethodCallHandler(this)
        var context = flutterPluginBinding.applicationContext as Application
        context.registerActivityLifecycleCallbacks(object : ActivityLifecycleCallbacks {
            override fun onActivityPaused(activity: Activity) {
            }

            override fun onActivityStarted(activity: Activity) {
            }

            override fun onActivityDestroyed(activity: Activity) {
            }

            override fun onActivitySaveInstanceState(activity: Activity, outState: Bundle) {
            }

            override fun onActivityStopped(activity: Activity) {
            }

            override fun onActivityCreated(activity: Activity, savedInstanceState: Bundle?) {
                this@DStackSpyPlugin.activity = activity
            }

            override fun onActivityResumed(activity: Activity) {
                this@DStackSpyPlugin.activity = activity
            }
        })
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        if (call.method == "getPlatformVersion") {
            result.success("Android ${android.os.Build.VERSION.RELEASE}")
        } else if (call.method == "spySendScreenShotActionToNative") {
            val arguments = call.arguments as Map<*, *>
            handleSpySendScreenShotActionToNative(arguments)
        } else {
            result.notImplemented()
        }
    }

    private fun handleSpySendScreenShotActionToNative(arguments: Map<*, *>?) {
        if (arguments == null) {
            return
        }
        val target: String = arguments["target"] as String
        if (TextUtils.isEmpty(target)) {
            return
        }
        var img = SnapShotUtils.getImgBase64(activity)
        if (TextUtils.isEmpty(img)) {
            img = ""
        } else {
            img = "data:image/png;base64,$img"
        }
        spyReceiveScreenShotFromNative(target, img)

    }

    private fun spyReceiveScreenShotFromNative(target: String, img: String) {
        Log.e("dstackspy", "spyReceiveScreenShotFromNative")
        val resultMap: HashMap<String?, Any?> = HashMap<String?, Any?>()
        resultMap["target"] = target
        resultMap["imageData"] = img
        channel.invokeMethod("spyReceiveScreenShotFromNative", resultMap)
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}
