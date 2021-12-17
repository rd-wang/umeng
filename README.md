# wisdom_umeng

A new flutter plugin project.

## Getting Started

This project is a starting point for a Flutter
[plug-in package](https://flutter.dev/developing-packages/),
a specialized package that includes platform-specific implementation code for
Android and/or iOS.

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

#如何使用
使用该插件，安卓manifest中一些平台的参数也需要修改

#接口说明

## sdk 初始化
WisdomUmeng

###
androidAppKey 友盟平台安卓应用app_key
iosAppKey     友盟平台ios应用app_key
channel       可不传，
channelsKey   主要针对安卓平台中各个厂商的平台注册账号：规则如下
{
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
}

static Future<dynamic> initUmeng(String androidAppKey,String iosAppKey,Map<String,dynamic> channelsKey,{String channel = 'Umeng'})

