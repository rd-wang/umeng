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
static Future<dynamic> initUmeng(String androidAppKey,String iosAppKey,{bool isStatistic = true,bool isPush = true,String channel = 'Umeng'}) {
