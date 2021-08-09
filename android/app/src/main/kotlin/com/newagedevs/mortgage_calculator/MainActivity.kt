package com.newagedevs.mortgage_calculator

import android.os.Bundle
import com.newagedevs.mortgage_calculator.extentions.checkFolder
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.plugins.util.GeneratedPluginRegister
import io.flutter.plugin.common.MethodChannel


class MainActivity: FlutterActivity() {

    private val channel = "flutter.native/helper"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        GeneratedPluginRegister.registerGeneratedPlugins(FlutterEngine(this))

        MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, channel).setMethodCallHandler { call, result ->

            when {
                call.method.equals("askStoragePermission") -> {

                    val directoryName = call.argument<String>("dirName")?:"Empty"

                    val greetings = onPermissionGranted(directoryName)

                    result.success(greetings)

                }

            }

        }
    }


    private fun onPermissionGranted(directoryName:String):Boolean {
        return checkFolder(this, directoryName)
    }

}
