import 'package:umeng_common_sdk/umeng_common_sdk.dart';

//------------------------------------------------------------统计相关部分----------------------------------
class WisdomCount {
  static void statisticConfiger() {
    // 手动采集页面信息
    UmengCommonSdk.setPageCollectionModeManual();
  }

  // 登录用户账号
  static void profileSignIn(String userID) {
    UmengCommonSdk.onProfileSignIn(userID);
  }

  // 退出用户账号
  static void profileSignOff() {
    UmengCommonSdk.onProfileSignOff();
  }

  // 进入页面
  static void pageStart(String pageName) {
    UmengCommonSdk.onPageStart(pageName);
    print('统计：WisdomUmeng______pageName___start____' + pageName);
  }

  // 退出页面
  static void pageEnd(String pageName) {
    UmengCommonSdk.onPageEnd(pageName);
    print('统计：WisdomUmeng______pageName___end______' + pageName);
  }

  //自定义事件
  static void event(String event, Map<String, dynamic> properties) {
    UmengCommonSdk.onEvent(event, properties ?? {event: event});
    print('统计：WisdomUmeng______event___' + event);
  }
}