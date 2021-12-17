package com.roobo.wisdomUmeng.wisdom_umeng.umeng;

import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.graphics.BitmapFactory;
import android.os.Build;
import android.text.TextUtils;
import android.util.Log;

import com.roobo.wisdomUmeng.wisdom_umeng.MainActivity;
import com.roobo.wisdomUmeng.wisdom_umeng.R;
import com.umeng.message.UmengMessageService;
import com.umeng.message.entity.UMessage;

import org.json.JSONObject;


public class YouMengPushService extends UmengMessageService {

    public void getNotification(Context context, String title, String msg, String notices) {

        NotificationManager manager = (NotificationManager) context.getSystemService(Context.NOTIFICATION_SERVICE);
        int id = (int) (System.currentTimeMillis() / 1000);

        Intent secondIntent = new Intent(this, MainActivity.class);
        secondIntent.putExtra("notice", notices);
        Log.i("Bundle______", notices.toString());
        secondIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_NO_ANIMATION
                | Intent.FLAG_ACTIVITY_CLEAR_TOP | Intent.FLAG_ACTIVITY_SINGLE_TOP);
        PendingIntent pendingIntent = PendingIntent.getActivity(this, id,
                secondIntent, PendingIntent.FLAG_UPDATE_CURRENT);


        if (Build.VERSION.SDK_INT >= 26) {  //判断8.0，若为8.0型号的手机进行创下一下的通知栏
            NotificationChannel channel = new NotificationChannel("channel_id", "channel_name", NotificationManager.IMPORTANCE_HIGH);
            if (manager != null) {
                manager.createNotificationChannel(channel);
            }
            Notification.Builder builder = new Notification.Builder(context, "channel_id");
//            builder.setSmallIcon(R.mipmap.ic_launcher)
            builder.setWhen(System.currentTimeMillis())
//                    .setLargeIcon(BitmapFactory.decodeResource(context.getResources(), R.mipmap.ic_launcher))
                    .setContentTitle(title)
                    .setContentText(msg)
                    .setAutoCancel(true)
                    .setContentIntent(pendingIntent);
            manager.notify(id, builder.build());
        } else {
            Notification.Builder builder = new Notification.Builder(context);
//            builder.setSmallIcon(R.mipmap.ic_launcher)
            builder.setWhen(System.currentTimeMillis())
//                    .setLargeIcon(BitmapFactory.decodeResource(context.getResources(), R.mipmap.ic_launcher))
                    .setContentTitle(title)
                    .setContentText(msg)
                    .setAutoCancel(true)
                    .setContentIntent(pendingIntent);

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN) {
                manager.notify(id, builder.build());
            }
        }
    }

    @Override
    public void onMessage(Context context, Intent intent) {
        try {

            Intent data = new Intent(intent);
            final String message = intent.getStringExtra("body");
            if (TextUtils.isEmpty(message)) {
                return;
            }
            final UMessage msg = new UMessage(new JSONObject(message));
            getNotification(context, msg.title, msg.text, message);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
