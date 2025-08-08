import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_wechatpay_plugin/flutter_wechatpay_plugin.dart';
import 'package:flutter_wechatpay_plugin/flutter_wechatpay_plugin_platform_interface.dart';
import 'package:flutter_wechatpay_plugin/flutter_wechatpay_plugin_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterWechatpayPluginPlatform
    with MockPlatformInterfaceMixin
    implements FlutterWechatpayPluginPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<bool> initWechatPay({
    required String appId,
    required String partnerId,
    String? universalLink,
  }) =>
      Future.value(true);

  @override
  Future<bool> registerApp({
    required String appId,
    String? universalLink,
  }) =>
      Future.value(true);

  @override
  Future<Map<String, dynamic>> pay({
    required String partnerId,
    required String prepayId,
    required String packageValue,
    required String nonceStr,
    required String timeStamp,
    required String sign,
  }) =>
      Future.value({'success': true, 'message': 'Payment successful'});

  @override
  Future<Map<String, dynamic>> queryOrder({
    required String orderId,
  }) =>
      Future.value({'success': true, 'orderId': orderId, 'status': 'SUCCESS'});

  @override
  Future<bool> isWechatInstalled() => Future.value(true);
}

void main() {
  final FlutterWechatpayPluginPlatform initialPlatform =
      FlutterWechatpayPluginPlatform.instance;

  test('$MethodChannelFlutterWechatpayPlugin is the default instance', () {
    expect(
        initialPlatform, isInstanceOf<MethodChannelFlutterWechatpayPlugin>());
  });

  test('getPlatformVersion', () async {
    FlutterWechatpayPlugin flutterWechatpayPlugin = FlutterWechatpayPlugin();
    MockFlutterWechatpayPluginPlatform fakePlatform =
        MockFlutterWechatpayPluginPlatform();
    FlutterWechatpayPluginPlatform.instance = fakePlatform;

    expect(await flutterWechatpayPlugin.getPlatformVersion(), '42');
  });

  test('initWechatPay', () async {
    FlutterWechatpayPlugin flutterWechatpayPlugin = FlutterWechatpayPlugin();
    MockFlutterWechatpayPluginPlatform fakePlatform =
        MockFlutterWechatpayPluginPlatform();
    FlutterWechatpayPluginPlatform.instance = fakePlatform;

    final result = await flutterWechatpayPlugin.initWechatPay(
      appId: 'test_app_id',
      partnerId: 'test_partner_id',
    );
    expect(result, true);
  });

  test('initWechatPay with universalLink', () async {
    FlutterWechatpayPlugin flutterWechatpayPlugin = FlutterWechatpayPlugin();
    MockFlutterWechatpayPluginPlatform fakePlatform =
        MockFlutterWechatpayPluginPlatform();
    FlutterWechatpayPluginPlatform.instance = fakePlatform;

    final result = await flutterWechatpayPlugin.initWechatPay(
      appId: 'test_app_id',
      partnerId: 'test_partner_id',
      universalLink: 'https://example.com/wechat',
    );
    expect(result, true);
  });

  test('registerApp', () async {
    FlutterWechatpayPlugin flutterWechatpayPlugin = FlutterWechatpayPlugin();
    MockFlutterWechatpayPluginPlatform fakePlatform =
        MockFlutterWechatpayPluginPlatform();
    FlutterWechatpayPluginPlatform.instance = fakePlatform;

    final result = await flutterWechatpayPlugin.registerApp(
      appId: 'test_app_id',
    );
    expect(result, true);
  });

  test('registerApp with universalLink', () async {
    FlutterWechatpayPlugin flutterWechatpayPlugin = FlutterWechatpayPlugin();
    MockFlutterWechatpayPluginPlatform fakePlatform =
        MockFlutterWechatpayPluginPlatform();
    FlutterWechatpayPluginPlatform.instance = fakePlatform;

    final result = await flutterWechatpayPlugin.registerApp(
      appId: 'test_app_id',
      universalLink: 'https://example.com/wechat',
    );
    expect(result, true);
  });

  test('pay', () async {
    FlutterWechatpayPlugin flutterWechatpayPlugin = FlutterWechatpayPlugin();
    MockFlutterWechatpayPluginPlatform fakePlatform =
        MockFlutterWechatpayPluginPlatform();
    FlutterWechatpayPluginPlatform.instance = fakePlatform;

    final result = await flutterWechatpayPlugin.pay(
      partnerId: 'test_partner_id',
      prepayId: 'test_prepay_id',
      packageValue: 'Sign=WXPay',
      nonceStr: 'test_nonce_str',
      timeStamp: '1234567890',
      sign: 'test_sign',
    );

    expect(result, isA<Map<String, dynamic>>());
    expect(result['success'], true);
    expect(result['message'], 'Payment successful');
  });

  test('queryOrder', () async {
    FlutterWechatpayPlugin flutterWechatpayPlugin = FlutterWechatpayPlugin();
    MockFlutterWechatpayPluginPlatform fakePlatform =
        MockFlutterWechatpayPluginPlatform();
    FlutterWechatpayPluginPlatform.instance = fakePlatform;

    final orderId = 'test_order_id';
    final result = await flutterWechatpayPlugin.queryOrder(
      orderId: orderId,
    );

    expect(result, isA<Map<String, dynamic>>());
    expect(result['success'], true);
    expect(result['orderId'], orderId);
    expect(result['status'], 'SUCCESS');
  });

  test('isWechatInstalled', () async {
    FlutterWechatpayPlugin flutterWechatpayPlugin = FlutterWechatpayPlugin();
    MockFlutterWechatpayPluginPlatform fakePlatform =
        MockFlutterWechatpayPluginPlatform();
    FlutterWechatpayPluginPlatform.instance = fakePlatform;

    final result = await flutterWechatpayPlugin.isWechatInstalled();
    expect(result, true);
  });
}
