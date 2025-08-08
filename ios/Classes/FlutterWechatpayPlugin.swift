/*
 * Copyright (c) 2025 PlaudAI. All rights reserved.
 * Author: Neo.Wang@plaud.ai
 */

import Flutter
import UIKit
import WechatOpenSDK

public class FlutterWechatpayPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_wechatpay_plugin", binaryMessenger: registrar.messenger())
    let instance = FlutterWechatpayPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
      result("iOS " + UIDevice.current.systemVersion)
    case "initWechatPay":
      result(notSupportedPlatformError())
    case "registerApp":
      result(notSupportedPlatformError())
    case "pay":
      result(notSupportedPlatformError())
    case "queryOrder":
      result(notSupportedPlatformError())
    case "isWechatInstalled":
      result(notSupportedPlatformError())
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func notSupportedPlatformError() -> FlutterError {
    return FlutterError(code: "UNSUPPORTED_PLATFORM", 
                         message: "WeChat Pay is not supported on iOS platform yet", 
                         details: nil)
  }
}
