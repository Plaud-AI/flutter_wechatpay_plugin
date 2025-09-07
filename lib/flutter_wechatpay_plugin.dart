/*
 * Copyright (c) 2025 PlaudAI. All rights reserved.
 * Author: Neo.Wang@plaud.ai
 */

import 'flutter_wechatpay_plugin_platform_interface.dart';

class FlutterWechatpayPlugin {
  /// Get platform version
  Future<String?> getPlatformVersion() {
    return FlutterWechatpayPluginPlatform.instance.getPlatformVersion();
  }

  /// Initialize WeChat Pay
  Future<bool> initWechatPay({
    required String appId,
    required String partnerId,
    String? universalLink,
  }) {
    return FlutterWechatpayPluginPlatform.instance.initWechatPay(
      appId: appId,
      partnerId: partnerId,
      universalLink: universalLink,
    );
  }

  /// Register app for WeChat
  Future<bool> registerApp({
    required String appId,
    String? universalLink,
  }) {
    return FlutterWechatpayPluginPlatform.instance.registerApp(
      appId: appId,
      universalLink: universalLink,
    );
  }

  /// Initiate WeChat Pay payment
  Future<Map<String, dynamic>> pay({
    required String appId,
    required String partnerId,
    required String prepayId,
    required String packageValue,
    required String nonceStr,
    required String timeStamp,
    required String sign,
  }) {
    return FlutterWechatpayPluginPlatform.instance.pay(
      appId: appId,
      partnerId: partnerId,
      prepayId: prepayId,
      packageValue: packageValue,
      nonceStr: nonceStr,
      timeStamp: timeStamp,
      sign: sign,
    );
  }

  /// Check if WeChat is installed
  Future<bool> isWechatInstalled() {
    return FlutterWechatpayPluginPlatform.instance.isWechatInstalled();
  }

  /// Sign WeChat Pay contract
  Future<Map<String, dynamic>> signContract({
    required String preEntrustwebId,
  }) {
    return FlutterWechatpayPluginPlatform.instance.signContract(
      preEntrustwebId: preEntrustwebId,
    );
  }
}
