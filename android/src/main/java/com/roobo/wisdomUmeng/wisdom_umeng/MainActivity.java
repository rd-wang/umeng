package com.roobo.wisdomUmeng.wisdom_umeng;

import android.content.Intent;
import android.os.Bundle;
import android.os.Looper;
import android.os.Handler;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.roobo.wisdomUmeng.wisdom_umeng.umeng.MyPreferences;
import com.umeng.analytics.MobclickAgent;
import com.umeng.commonsdk.UMConfigure;
import com.umeng.message.PushAgent;

import java.util.HashMap;
import java.util.Map;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.plugin.common.EventChannel;

public class MainActivity extends FlutterActivity {
    private EventChannel.EventSink mEventSink;
    Handler mHandler = new Handler(Looper.myLooper());

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        UMConfigure.preInit(this, "615417d7cf85ee1810eb7202", "Umeng");
        UMConfigure.setLogEnabled(true);
        //设置上下文
        com.umeng.umeng_common_sdk.UmengCommonSdkPlugin.setContext(this);
        android.util.Log.i("UMLog", "onCreate@MainActivity");

        if (MyPreferences.getInstance(this).hasAgreePrivacyAgreement()) {
            PushAgent.getInstance(this).onAppStart();
        }

        eventChannelFunction();
    }

    @Override
    protected void onNewIntent(@NonNull Intent intent) {
        super.onNewIntent(intent);
        setIntent(intent);
    }

    @Override
    protected void onPause() {
        super.onPause();
        MobclickAgent.onPause(this);
    }

    @Override
    protected void onResume() {
        super.onResume();
        MobclickAgent.onResume(this);

        String notice = getIntent().getStringExtra("notice");
        String test = getIntent().getStringExtra("test");
        Log.i("MainActivity_____", test != null ? test : "test2222222222222");
        Log.i("MainActivity_____", notice != null ? notice : "notice2222222222222");
        if (notice != null) {
            Log.i("MainActivity_____", notice);
            pushMessage(notice);
        }
    }

    public void pushMessage(String msg) {
        io.flutter.Log.i("PushMessageActivity", msg);
        if (mEventSink != null) {
            mEventSink.success(msg);
        }
    }

    private void eventChannelFunction() {
        EventChannel lEventChannel = new EventChannel(getFlutterEngine().getDartExecutor().getBinaryMessenger(), "WisdomMessageEventChannel");
        lEventChannel.setStreamHandler(
                new EventChannel.StreamHandler() {
                    @Override
                    public void onListen(Object o, EventChannel.EventSink eventSink) {
                        mEventSink = eventSink;
                        mHandler.post(new Runnable() {
                            @Override
                            public void run() {
                                Map<String, Object> resultMap = new HashMap<>();
                                resultMap.put("message", "注册成功");
                                resultMap.put("code", 200);
                                eventSink.success(resultMap);
                            }
                        });
                    }

                    @Override
                    public void onCancel(Object o) {

                    }

                }
        );
    }
}
