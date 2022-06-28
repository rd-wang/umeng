import 'dart:async';

import 'package:flutter/services.dart';
import 'package:umeng_common_sdk/umeng_common_sdk.dart';
import 'package:wisdom_umeng/wisdom_push.dart';
import 'package:wisdom_umeng/wisdom_statistic.dart';

// 统计+推送
class WisdomUmeng {
  static const MethodChannel methodChannel =
      const MethodChannel('wisdom_umeng');

  static Future<String> get platformVersion async {
    final String version =
        await methodChannel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<dynamic> initUmeng(String androidAppKey, String iosAppKey,
      {bool isStatistic = true, bool isPush = true, String channel = 'Umeng'}) {
    UmengCommonSdk.initCommon(androidAppKey, iosAppKey, channel);
    final dynamic result = methodChannel.invokeMethod("init");
    if (isStatistic) {
      WisdomCount.statisticConfiger();
    }
    if (isPush) {
      WisdomPush.pushConfiger();
    }
    return result;
  }

  static pushErrors(Map<String, dynamic> error) {
    methodChannel.invokeListMethod("pushError", error);
  }
}
