package com.example.speechtotext
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.Bundle
import android.telephony.TelephonyManager
import android.util.Log
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import kotlin.math.log

class MainActivity: FlutterActivity() {
  private val CHANNEL = "com.yourapp/call"
  private lateinit var methodChannel: MethodChannel


  override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)
    methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
    Log.d("starter", "Debug starter")
    val receiver = CallReceiver()
    receiver.setMethodChannel(methodChannel)

    registerReceiver(receiver, IntentFilter("android.intent.action.PHONE_STATE"))

  }

}

  class CallReceiver : BroadcastReceiver() {
    private var methodChannel: MethodChannel? = null

    fun setMethodChannel(channel: MethodChannel) {
      methodChannel = channel
    }
    override fun onReceive(context: Context, intent: Intent) {
      val state = intent.getStringExtra(TelephonyManager.EXTRA_STATE)
      when (state) {
        TelephonyManager.EXTRA_STATE_RINGING -> {
          Log.d("CALL_STATE", "Incoming call is ringing")
         // Toast.makeText(context, "Incoming call is ringing", Toast.LENGTH_SHORT).show()
          methodChannel?.invokeMethod("incoming_call", null)
        }
        TelephonyManager.EXTRA_STATE_OFFHOOK -> {
          Log.d("CALL_STATE", "Call answered or active")
        //  Toast.makeText(context, "Call answered", Toast.LENGTH_SHORT).show()
          methodChannel?.invokeMethod("call_picked", null)
        }
        TelephonyManager.EXTRA_STATE_IDLE -> {
          Log.d("CALL_STATE", "Call ended or idle")
        //  Toast.makeText(context, "Call ended", Toast.LENGTH_SHORT).show()
          methodChannel?.invokeMethod("call_ended", null)
        }
      }
    }

}
