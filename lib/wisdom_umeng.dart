
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
    final String version = await methodChannel.invokeMethod('getPlatformVersion');
    return version;
  }

  // 参数说明
  // channelsKey 作为友盟统计各个平台申请的key和秘钥等等,主要针对安卓平台，规则readme
  static Future<dynamic> initUmeng(String androidAppKey,String iosAppKey,Map<String,dynamic> channelsKey,{String channel = 'Umeng'}) {
    UmengCommonSdk.initCommon(androidAppKey, iosAppKey, channel);
    final dynamic result = methodChannel.invokeMethod("init",channelsKey);
    if (channelsKey['statistic'] != null && channelsKey['statistic']) {
      WisdomCount.statisticConfiger();
    }
    if (channelsKey['push'] != null && channelsKey['push']) {
      WisdomPush.pushConfiger();
    }
    return result;
  }
}
