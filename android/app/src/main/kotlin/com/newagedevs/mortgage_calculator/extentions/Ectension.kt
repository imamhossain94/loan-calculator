package com.newagedevs.mortgage_calculator.extentions

import android.content.Context
import android.os.Build
import android.os.Environment
import android.util.Log
import android.widget.Toast
import java.io.File


fun showToast(context: Context, message: String) {
    Toast.makeText(context, message, Toast.LENGTH_SHORT).show()
}

fun checkFolder(context: Context, folderName: String):Boolean {

    val file: File = if (Build.VERSION.SDK_INT <= Build.VERSION_CODES.Q) {
        File(context.getExternalFilesDir(null).toString() + "/$folderName")
    } else {
        File(Environment.getExternalStorageDirectory().absolutePath + "/$folderName")
    }

    return if (!file.exists()) {
        file.mkdirs()

        Log.d("Tag--------------------", file.toString());
        true
    }else{
        showToast(context, "Failed to create directories")
        false
    }
}
