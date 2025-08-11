import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_wechatpay_plugin/flutter_wechatpay_plugin_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelFlutterWechatpayPlugin platform =
      MethodChannelFlutterWechatpayPlugin();
  const MethodChannel channel = MethodChannel('flutter_wechatpay_plugin');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        switch (methodCall.method) {
          case 'getPlatformVersion':
            return '42';
          case 'initWechatPay':
            return true;
          case 'registerApp':
            return true;
          case 'pay':
            return {'success': true, 'message': 'Payment successful'};
          case 'queryOrder':
            return {
              'success': true,
              'orderId': methodCall.arguments['orderId'],
              'status': 'SUCCESS'
            };
          case 'isWechatInstalled':
            return true;
          default:
            return null;
        }
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });

  test('initWechatPay', () async {
    final result = await platform.initWechatPay(
      appId: 'test_app_id',
      partnerId: 'test_partner_id',
    );
    expect(result, true);
  });

  test('initWechatPay with universalLink', () async {
    final result = await platform.initWechatPay(
      appId: 'test_app_id',
      partnerId: 'test_partner_id',
      universalLink: 'https://example.com/wechat',
    );
    expect(result, true);
  });

  test('registerApp', () async {
    final result = await platform.registerApp(
      appId: 'test_app_id',
    );
    expect(result, true);
  });

  test('registerApp with universalLink', () async {
    final result = await platform.registerApp(
      appId: 'test_app_id',
      universalLink: 'https://example.com/wechat',
    );
    expect(result, true);
  });

  test('pay', () async {
    final result = await platform.pay(
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

  test('isWechatInstalled', () async {
    final result = await platform.isWechatInstalled();
    expect(result, true);
  });
}
