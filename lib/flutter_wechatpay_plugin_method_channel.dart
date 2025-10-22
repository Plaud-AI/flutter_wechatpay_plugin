/*
 * Copyright (c) 2025 PlaudAI. All rights reserved.
 * Author: Neo.Wang@plaud.ai
 */

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_wechatpay_plugin_platform_interface.dart';

/// An implementation of [FlutterWechatpayPluginPlatform] that uses method channels.
class MethodChannelFlutterWechatpayPlugin
    extends FlutterWechatpayPluginPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_wechatpay_plugin');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<bool> initWechatPay({
    required String appId,
    required String partnerId,
    String? universalLink,
  }) async {
    final result = await methodChannel.invokeMethod<bool>('initWechatPay', {
      'appId': appId,
      'partnerId': partnerId,
      'universalLink': universalLink,
    });
    return result ?? false;
  }

  @override
  Future<Map<String, dynamic>> pay({
    required String prepayId,
    required String packageValue,
    required String nonceStr,
    required String timeStamp,
    required String sign,
  }) async {
    final result =
        await methodChannel.invokeMethod<Map<dynamic, dynamic>>('pay', {
      'prepayId': prepayId,
      'packageValue': packageValue,
      'nonceStr': nonceStr,
      'timeStamp': timeStamp,
      'sign': sign,
    });
    return Map<String, dynamic>.from(result ?? {});
  }

  @override
  Future<bool> isWechatInstalled() async {
    final result = await methodChannel.invokeMethod<bool>('isWechatInstalled');
    return result ?? false;
  }

  @override
  Future<bool> registerApp({
    required String appId,
    String? universalLink,
  }) async {
    final result = await methodChannel.invokeMethod<bool>('registerApp', {
      'appId': appId,
      'universalLink': universalLink,
    });
    return result ?? false;
  }

  @override
  Future<Map<String, dynamic>> signContract({
    required String preEntrustwebId,
  }) async {
    final result =
        await methodChannel.invokeMethod<Map<dynamic, dynamic>>('signContract', {
      'preEntrustwebId': preEntrustwebId,
    });
    return Map<String, dynamic>.from(result ?? {});
  }
}
