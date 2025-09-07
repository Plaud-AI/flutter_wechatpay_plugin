/*
 * Copyright (c) 2025 PlaudAI. All rights reserved.
 * Author: Neo.Wang@plaud.ai
 */

package com.plaud.flutter_wechatpay_plugin

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry
import com.tencent.mm.opensdk.modelpay.PayReq
import com.tencent.mm.opensdk.modelbase.BaseReq
import com.tencent.mm.opensdk.modelbiz.WXLaunchMiniProgram
import com.tencent.mm.opensdk.modelbiz.SubscribeMessage
import com.tencent.mm.opensdk.modelbiz.WXOpenBusinessWebview
import com.tencent.mm.opensdk.openapi.IWXAPI
import com.tencent.mm.opensdk.openapi.WXAPIFactory
import java.util.concurrent.Executors
import java.util.concurrent.CompletableFuture
import java.util.concurrent.TimeUnit
import java.net.URLEncoder
import java.nio.charset.StandardCharsets

/** FlutterWechatpayPlugin - WeChat Pay payment integration for Flutter */
class FlutterWechatpayPlugin: FlutterPlugin, MethodCallHandler, ActivityAware {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private lateinit var context: Context
  private var activity: Activity? = null
  private val executor = Executors.newSingleThreadExecutor()
  
  // WeChat API instance
  private var wxApi: IWXAPI? = null
  
  // WeChat configuration
  private var appId: String = ""
  private var partnerId: String = ""
  private var universalLink: String = ""

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_wechatpay_plugin")
    channel.setMethodCallHandler(this)
    context = flutterPluginBinding.applicationContext
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    when (call.method) {
      "getPlatformVersion" -> {
        result.success("${android.os.Build.VERSION.RELEASE}")
      }
      "initWechatPay" -> {
        val appId = call.argument<String>("appId") ?: ""
        val partnerId = call.argument<String>("partnerId") ?: ""
        val universalLink = call.argument<String>("universalLink") ?: ""
        
        if (appId.isNotEmpty() && partnerId.isNotEmpty()) {
          this.appId = appId
          this.partnerId = partnerId
          this.universalLink = universalLink
          
          // Initialize WeChat API
          wxApi = WXAPIFactory.createWXAPI(context, appId, false)
          val success = wxApi?.registerApp(appId) ?: false
          result.success(success)
        } else {
          result.success(false)
        }
      }
      "registerApp" -> {
        val appId = call.argument<String>("appId") ?: ""
        val universalLink = call.argument<String>("universalLink") ?: ""
        
        if (appId.isNotEmpty()) {
          wxApi = WXAPIFactory.createWXAPI(context, appId, false)
          val success = wxApi?.registerApp(appId) ?: false
          result.success(success)
        } else {
          result.success(false)
        }
      }
      "pay" -> {
        val prepayId = call.argument<String>("prepayId") ?: ""
        val packageValue = call.argument<String>("packageValue") ?: ""
        val nonceStr = call.argument<String>("nonceStr") ?: ""
        val timeStamp = call.argument<String>("timeStamp") ?: ""
        val sign = call.argument<String>("sign") ?: ""
        
        if (partnerId.isEmpty() || prepayId.isEmpty() || packageValue.isEmpty() || 
            nonceStr.isEmpty() || timeStamp.isEmpty() || sign.isEmpty()) {
          result.error("INVALID_PARAMETERS", "All payment parameters are required", null)
          return
        }
        
        if (activity == null) {
          result.error("NO_ACTIVITY", "Activity is not available", null)
          return
        }
        
        if (wxApi == null) {
          result.error("WECHAT_NOT_INITIALIZED", "WeChat API is not initialized", null)
          return
        }
        
        // Use WeChat SDK for payment
        executor.execute {
          try {
            val payReq = PayReq()
            payReq.appId = this.appId
            payReq.partnerId = this.partnerId
            payReq.prepayId = prepayId
            payReq.packageValue = packageValue
            payReq.nonceStr = nonceStr
            payReq.timeStamp = timeStamp
            payReq.sign = sign
            
            val success = wxApi?.sendReq(payReq) ?: false
            
            activity?.runOnUiThread {
              val response = mutableMapOf<String, Any>()
              response["success"] = success
              response["message"] = if (success) "Payment request sent successfully" else "Failed to send payment request"
              result.success(response)
            }
          } catch (e: Exception) {
            activity?.runOnUiThread {
              val response = mutableMapOf<String, Any>()
              response["success"] = false
              response["message"] = "Payment failed: ${e.message}"
              result.success(response)
            }
          }
        }
      }
      "isWechatInstalled" -> {
        val isInstalled = isWechatAppInstalled()
        result.success(isInstalled)
      }
      "signContract" -> {
        val preEntrustwebId = call.argument<String>("preEntrustwebId") ?: ""
        
        if (preEntrustwebId.isEmpty()) {
          result.error("INVALID_PARAMETERS", "preEntrustwebId is required", null)
          return
        }
        
        if (activity == null) {
          result.error("NO_ACTIVITY", "Activity is not available", null)
          return
        }
        
        if (wxApi == null) {
          result.error("WECHAT_NOT_INITIALIZED", "WeChat API is not initialized", null)
          return
        }
        
        // Check if WeChat is installed before proceeding
        if (!isWechatAppInstalled()) {
          result.error("WECHAT_NOT_INSTALLED", "WeChat app is not installed", null)
          return
        }
        
        // Execute contract signing
        executor.execute {
          try {
            val req = WXOpenBusinessWebview.Req()
            req.businessType = 12 // 委托代扣签约 (Contract signing business type)
            
            // On Android, the parameters are passed in a HashMap to the queryInfo property.
            val queryInfo = HashMap<String, String>()
            queryInfo["pre_entrustweb_id"] = preEntrustwebId
            req.queryInfo = queryInfo
            
            val success = wxApi?.sendReq(req) ?: false
            
            activity?.runOnUiThread {
              val response = mutableMapOf<String, Any>()
              response["success"] = success
              response["message"] = if (success) "Contract signing request sent successfully" else "Failed to send contract signing request"
              response["preEntrustwebId"] = preEntrustwebId
              result.success(response)
            }
          } catch (e: Exception) {
            activity?.runOnUiThread {
              val response = mutableMapOf<String, Any>()
              response["success"] = false
              response["message"] = "Contract signing failed: ${e.message}"
              response["error"] = e.javaClass.simpleName
              result.success(response)
            }
          }
        }
      }
      else -> {
        result.notImplemented()
      }
    }
  }

  private fun isWechatAppInstalled(): Boolean {
    return try {
      val packageManager = context.packageManager
      packageManager.getPackageInfo("com.tencent.mm", PackageManager.GET_ACTIVITIES)
      true
    } catch (e: Exception) {
      false
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activity = binding.activity
  }

  override fun onDetachedFromActivityForConfigChanges() {
    activity = null
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    activity = binding.activity
  }

  override fun onDetachedFromActivity() {
    activity = null
  }
}
