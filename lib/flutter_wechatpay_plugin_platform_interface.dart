/*
 * Copyright (c) 2025 PlaudAI. All rights reserved.
 * Author: Neo.Wang@plaud.ai
 */

import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_wechatpay_plugin_method_channel.dart';

abstract class FlutterWechatpayPluginPlatform extends PlatformInterface {
  /// Constructs a FlutterWechatpayPluginPlatform.
  FlutterWechatpayPluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterWechatpayPluginPlatform _instance =
      MethodChannelFlutterWechatpayPlugin();

  /// The default instance of [FlutterWechatpayPluginPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterWechatpayPlugin].
  static FlutterWechatpayPluginPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterWechatpayPluginPlatform] when
  /// they register themselves.
  static set instance(FlutterWechatpayPluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  /// Initialize WeChat Pay
  Future<bool> initWechatPay({
    required String appId,
    required String partnerId,
    String? universalLink,
  }) {
    throw UnimplementedError('initWechatPay() has not been implemented.');
  }

  /// Initiate WeChat Pay payment
  Future<Map<String, dynamic>> pay({
    required String prepayId,
    required String packageValue,
    required String nonceStr,
    required String timeStamp,
    required String sign,
  }) {
    throw UnimplementedError('pay() has not been implemented.');
  }

  /// Check if WeChat is installed
  Future<bool> isWechatInstalled() {
    throw UnimplementedError('isWechatInstalled() has not been implemented.');
  }

  /// Register app for WeChat
  Future<bool> registerApp({
    required String appId,
    String? universalLink,
  }) {
    throw UnimplementedError('registerApp() has not been implemented.');
  }

  /// Sign WeChat Pay contract
  Future<Map<String, dynamic>> signContract({
    required String preEntrustwebId,
  }) {
    throw UnimplementedError('signContract() has not been implemented.');
  }
}
