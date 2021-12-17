import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:wisdom_umeng/wisdom_umeng.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();

    initWisdomUmengSDK();
  }

  initWisdomUmengSDK() {
    Map map = <String,dynamic>{
      "ios_app_key" : "61711e2ae0f9bb492b382e10",
      "ios_master_secret": "7gvel6ey6f3cqtx5oarfgqhdh6locwpk",
      "ios_channel" : "App Store",

      "android_app_key" : "615417d7cf85ee1810eb7202",
      "android_message_secret":"8f491f83094779cf3e906375010e0564",
      "android_master_secret":"nrfajkxzk8kszy6jmjz1h8jttkupyqu3",

      "android_xiaomi":"TyLBuvjHZSGiOaDSMwrE7g==",

      "android_huawei_app_id":"104693783",
      "android_huawei_secret":"d2c682ba40d189e58e43f10bb52d1c7fd310ca1cfa3753bf193e93d159ac5f7f",

      "android_meizu_app_id":"144453",
      "android_meizu_secret":"7d0689b325f14129aa6f460018dfec3a",

      "android_vivo_app_id":"105509251",
      "android_vivo_app_key":"dc1ed00f131dd580a9f6bdc81db48f6f",
      "android_vivo_app_secret":"797f45bf-66f4-451b-9b3e-e887f9c08b25",

      "android_oppo_app_key":"291aed75a8454943938f389bb068accb",
      "android_oppo_master_secret":"36530c85d976412392c646a73d283f87",

      "android_channel" : "Umeng"
    };
    WisdomUmeng.initUmeng(map["android_app_key"], map["ios_app_key"], map);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('Running on: $_platformVersion\n'),
        ),
      ),
    );
  }
}
