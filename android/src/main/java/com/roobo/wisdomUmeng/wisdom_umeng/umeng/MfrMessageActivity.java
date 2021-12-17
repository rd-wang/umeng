package com.roobo.wisdomUmeng.wisdom_umeng.umeng;

import android.content.Intent;
import android.os.Bundle;
import android.text.TextUtils;
import android.widget.TextView;

import com.roobo.wisdomUmeng.wisdom_umeng.R;
import com.umeng.message.UmengNotifyClickActivity;

import org.android.agoo.common.AgooConstants;

import io.flutter.Log;

/**
 * 厂商通道配置托管启动的Activity
 * 如点击小米、华为、OPPO、vivo等通道通知消息，启动的Activity
 */

public class MfrMessageActivity extends UmengNotifyClickActivity {
    private static final String TAG = "MfrMessageActivity";

    @Override
    protected void onCreate(Bundle bundle) {
        super.onCreate(bundle);
        setContentView(R.layout.mfr_message_layout);
    }

    @Override
    public void onMessage(Intent intent) {
        super.onMessage(intent);
        Bundle bundle = intent.getExtras();
        if (bundle != null) {
            Log.i(TAG, "bundle: " + bundle);
        }
        String body = intent.getStringExtra(AgooConstants.MESSAGE_BODY);
        Log.i(TAG, "body: " + body);
        if (!TextUtils.isEmpty(body)) {
            runOnUiThread(() -> ((TextView) findViewById(R.id.tv)).setText(body));
        }
    }

}
