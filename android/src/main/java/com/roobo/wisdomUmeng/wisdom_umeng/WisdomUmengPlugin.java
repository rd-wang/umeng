package com.roobo.wisdomUmeng.wisdom_umeng;

import static android.content.ContentValues.TAG;

import android.app.AppOpsManager;
import android.app.NotificationManager;
import android.content.Context;
import android.content.pm.ApplicationInfo;
import android.os.Build;

import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;

import com.roobo.wisdomUmeng.wisdom_umeng.umeng.MyPreferences;
import com.roobo.wisdomUmeng.wisdom_umeng.umeng.PushConstants;
import com.roobo.wisdomUmeng.wisdom_umeng.umeng.PushHelper;

import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.util.Map;

import io.flutter.Log;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** WisdomUmengPlugin */
public class WisdomUmengPlugin implements FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;
  private Context mContext = null;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    mContext = flutterPluginBinding.getApplicationContext();
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "wisdom_umeng");
    channel.setMethodCallHandler(this);
  }

  @RequiresApi(api = Build.VERSION_CODES.KITKAT)
  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (call.method.equals("getPlatformVersion")) {
      result.success("Android " + android.os.Build.VERSION.RELEASE);
    } else if (call.method.equals("init")) {
      Map<String,String> map = (Map<String, String>) call.arguments;
      if (map.containsKey("android_app_key")) {
        PushConstants.APP_KEY = map.get("android_app_key");
      } else if (map.containsKey("android_message_secret")) {
        PushConstants.MESSAGE_SECRET = map.get("android_message_secret");
      } else if (map.containsKey("android_xiaomi")) {
        PushConstants.MI_ID = map.get("android_xiaomi");
      } else if (map.containsKey("android_huawei_app_id")) {
        PushConstants.HUA_WEI_ID = map.get("android_huawei_app_id");
      } else if (map.containsKey("android_huawei_secret")) {
        PushConstants.HUA_WEI_SECRET = map.get("android_huawei_secret");
      } else if (map.containsKey("android_vivo_app_id")) {
        PushConstants.VIVO_ID = map.get("android_vivo_app_id");
      } else if (map.containsKey("android_vivo_app_key")) {
        PushConstants.VIVO_KEY = map.get("android_vivo_app_key");
      } else if (map.containsKey("android_vivo_app_secret")) {
        PushConstants.VIVO_SECRET = map.get("android_vivo_app_secret");
      } else if (map.containsKey("android_oppo_app_key")) {
        PushConstants.OPPO_KEY = map.get("android_oppo_app_key");
      } else if (map.containsKey("android_oppo_master_secret")) {
        PushConstants.OPPO_SECRET = map.get("android_oppo_master_secret");
      } else if (map.containsKey("android_channel")) {
        PushConstants.CHANNEL = map.get("android_channel");
      }
      return;
    } else if (call.method.equals("agree")) {
      Log.i(TAG, "agree_______________________");
      PushHelper.init(mContext);
      MyPreferences.getInstance(mContext).setAgreePrivacyAgreement(true);
      return;
    } else if (call.method.equals("askNotificationState")) {
      boolean isOpen = isNotificationEnabled(mContext);
      result.success(isOpen);
    } else {
      result.notImplemented();
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }


  @RequiresApi(api = Build.VERSION_CODES.KITKAT)
  public static boolean isNotificationEnabled(Context context) {

    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
      //8.0手机以上
      if (((NotificationManager) context.getSystemService(Context.NOTIFICATION_SERVICE)).getImportance() == NotificationManager.IMPORTANCE_NONE) {
        return false;
      }
    }

    String CHECK_OP_NO_THROW = "checkOpNoThrow";
    String OP_POST_NOTIFICATION = "OP_POST_NOTIFICATION";

    AppOpsManager mAppOps = (AppOpsManager) context.getSystemService(Context.APP_OPS_SERVICE);
    ApplicationInfo appInfo = context.getApplicationInfo();
    String pkg = context.getApplicationContext().getPackageName();
    int uid = appInfo.uid;

    Class appOpsClass = null;

    try {
      appOpsClass = Class.forName(AppOpsManager.class.getName());
      Method checkOpNoThrowMethod = appOpsClass.getMethod(CHECK_OP_NO_THROW, Integer.TYPE, Integer.TYPE,
              String.class);
      Field opPostNotificationValue = appOpsClass.getDeclaredField(OP_POST_NOTIFICATION);

      int value = (Integer) opPostNotificationValue.get(Integer.class);
      return ((Integer) checkOpNoThrowMethod.invoke(mAppOps, value, uid, pkg) == AppOpsManager.MODE_ALLOWED);

    } catch (Exception e) {
      e.printStackTrace();
    }
    return false;
  }
}
