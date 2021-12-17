import 'dart:io';

import 'package:flutter/services.dart';
import 'package:umeng_push_sdk/umeng_push_sdk.dart';
import 'package:wisdom_umeng/wisdom_umeng.dart';

//------------------------------------------------------------推送相关部分----------------------------------
typedef MessageCallBack = Function(dynamic data);

class WisdomPush {
  WisdomPush._();

  static final _instance = WisdomPush._();

  static WisdomPush get getInstance => _instance;

  static const String askNotificationStateKey = "askNotificationStateKey";
  static const EventChannel _eventChannel = const EventChannel('WisdomMessageEventChannel');

  static Future<void> askAgree() async {
    if (Platform.isAndroid) {
      return await WisdomUmeng.methodChannel.invokeMethod("agree");
    } else {
      return;
    }
  }

  static pushConfiger() async {
    askAgree();
    UmengPushSdk.register();
    if (!Platform.isIOS) {
      await UmengPushSdk.setPushEnable(true);
    }
  }

  // 获取安卓设备当前推送的状态，防止某些手机推送权限无法自动开启
  static Future<bool> askNotificationState() async {
    if (Platform.isAndroid) {
      return await WisdomUmeng.methodChannel.invokeMethod("askNotificationState");
    } else {
      return true;
    }
  }

  static Future<String> getPushToken() async {
    String pushToken = await UmengPushSdk.getRegisteredId();
    print("WisdomPush_____pushToken______$pushToken");
    return pushToken;
  }

  // 添加消息推送回调，根据自己的协议，自行解析
  static Future<dynamic> addNotificationListener(MessageCallBack messageCallBack) async {
    _eventChannel.receiveBroadcastStream().listen((arguments) {
      if (messageCallBack != null) {
        messageCallBack(arguments.toString());
      }
    },onError: (error) {
      print("WisdomUmeng________addNotificationListener___error");
      print(error);
    });
  }

}