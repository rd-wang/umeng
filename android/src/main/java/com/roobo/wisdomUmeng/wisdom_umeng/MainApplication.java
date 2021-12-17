package com.roobo.wisdomUmeng.wisdom_umeng;

import com.roobo.wisdomUmeng.wisdom_umeng.umeng.MyPreferences;
import com.roobo.wisdomUmeng.wisdom_umeng.umeng.PushHelper;
import com.umeng.commonsdk.UMConfigure;
import com.umeng.commonsdk.utils.UMUtils;
import com.umeng.message.PushAgent;

import io.flutter.app.FlutterApplication;

public class MainApplication extends FlutterApplication {
    @Override
    public void onCreate() {
        super.onCreate();
        UMConfigure.preInit(this, "615417d7cf85ee1810eb7202", "Umeng");
        UMConfigure.init(this, "615417d7cf85ee1810eb7202", "Umeng", UMConfigure.DEVICE_TYPE_PHONE, "8f491f83094779cf3e906375010e0564");
        UMConfigure.setLogEnabled(true);
        //设置上下文
        com.umeng.umeng_common_sdk.UmengCommonSdkPlugin.setContext(this);
        android.util.Log.i("MainApplication", "onCreate@MainApplication");


        if (MyPreferences.getInstance(this).hasAgreePrivacyAgreement()) {
            PushAgent.getInstance(this).onAppStart();
            if (UMUtils.isMainProgress(this)) {
                new Thread(new Runnable() {
                    @Override
                    public void run() {
                        PushHelper.init(getApplicationContext());
                    }
                }).start();
            } else {
                PushHelper.init(getApplicationContext());
            }
        }
    }
}
