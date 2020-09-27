package com.sanzeng.hello_watch.ui.service;

import android.app.KeyguardManager;
import android.app.Service;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.IBinder;
import android.os.PowerManager;
import android.support.annotation.Nullable;
import android.util.AndroidRuntimeException;
import android.util.Log;

import com.baidu.speech.EventListener;
import com.baidu.speech.EventManager;
import com.baidu.speech.EventManagerFactory;
import com.sanzeng.hello_watch.cts.AppConst;
import com.sanzeng.hello_watch.ui.activity.guide.AppStartActivity;
import com.sanzeng.hello_watch.ui.activity.login.LoginActivity;
import com.sanzeng.hello_watch.utils.PfsUtils;
import com.sanzeng.hello_watch.utils.ProjectPfs;
import com.sanzeng.hello_watch.utils.ViewUtils;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.HashMap;

/**
 * Created by home on 2017/6/21.
 */
public class WakeUpService extends Service {
    private static final String TAG = "WakeUpService";
    private EventManager mWpEventManager;
    private boolean voiceUp;

    @Override
    public void onCreate() {
        Log.i(TAG, "WakeUpService-onCreate");
       /* 注册屏幕唤醒时的广播 */
        IntentFilter mScreenOnFilter = new IntentFilter("android.intent.action.SCREEN_ON");
        WakeUpService.this.registerReceiver(mScreenOReceiver, mScreenOnFilter);

        /* 注册机器锁屏时的广播 */
        IntentFilter mScreenOffFilter = new IntentFilter("android.intent.action.SCREEN_OFF");
        WakeUpService.this.registerReceiver(mScreenOReceiver, mScreenOffFilter);

        // 唤醒功能打开步骤
        // 1) 创建唤醒事件管理器
        mWpEventManager = EventManagerFactory.create(this, "wp");

        // 3) 通知唤醒管理器, 启动唤醒功能
        HashMap params = new HashMap();
        params.put("kws-file", "assets:///WakeUp.bin"); // 设置唤醒资源, 唤醒资源请到 http://yuyin.baidu.com/wake#m4 来评估和导出
        mWpEventManager.send("wp.start", new JSONObject(params).toString(), null, 0, 0);
        super.onCreate();
    }


    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        //执行文件的下载或者播放等操作
        Log.i(TAG, "WakeUpService-onStartCommand");
         /*
          * 这里返回状态有三个值，分别是:
          * 1、START_STICKY：当服务进程在运行时被杀死，系统将会把它置为started状态，但是不保存其传递的Intent对象，之后，系统会尝试重新创建服务;
          * 2、START_NOT_STICKY：当服务进程在运行时被杀死，并且没有新的Intent对象传递过来的话，系统将会把它置为started状态，
          *   但是系统不会重新创建服务，直到startService(Intent intent)方法再次被调用;
          * 3、START_REDELIVER_INTENT：当服务进程在运行时被杀死，它将会在隔一段时间后自动创建，并且最后一个传递的Intent对象将会再次传递过来。
         */

        return START_STICKY;
    }


    @Override
    public void onDestroy() {
        Log.i(TAG, "WakeUpService-onDestroy");
        // 停止唤醒监听
        mWpEventManager.send("wp.stop", null, null, 0, 0);
        WakeUpService.this.unregisterReceiver(mScreenOReceiver);

        super.onDestroy();
    }

    @Nullable
    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }

    /**
     * 锁屏的管理类叫KeyguardManager，
     * 通过调用其内部类KeyguardLockmKeyguardLock的对象的disableKeyguard方法可以取消系统锁屏，
     * newKeyguardLock的参数用于标识是谁隐藏了系统锁屏
     */
    private BroadcastReceiver mScreenOReceiver = new BroadcastReceiver() {
        @Override
        public void onReceive(final Context context, Intent intent) {
            String action = intent.getAction();

            if (action.equals("android.intent.action.SCREEN_ON")) {
                if (voiceUp) {
                    voiceUp = false;
                    intent = new Intent(WakeUpService.this, AppStartActivity.class);
                    intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
                    intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                    startActivity(intent);
                }
            } else if (action.equals("android.intent.action.SCREEN_OFF")) {
//                voiceUp = false;
                // 2) 注册唤醒事件监听器
                mWpEventManager.registerListener(new EventListener() {
                    @Override
                    public void onEvent(String name, String params, byte[] data, int offset, int length) {
                        try {
                            JSONObject json = new JSONObject(params);
                            if ("wp.data".equals(name)) { // 每次唤醒成功, 将会回调name=wp.data的时间, 被激活的唤醒词在params的word字段
                                String word = json.getString("word");
//                                ViewUtils.showToast(WakeUpService.this, "唤醒成功");
                                voiceUp = true;
                                wakeUpAndUnlock(context);
                            } else if ("wp.exit".equals(name)) {
                                Log.i("唤醒已经停止: ", params + "\r\n");
                            }
                        } catch (JSONException e) {
                            throw new AndroidRuntimeException(e);
                        }
                    }
                });


            }
        }

    };


    public static void wakeUpAndUnlock(Context context) {
        KeyguardManager km = (KeyguardManager) context.getSystemService(Context.KEYGUARD_SERVICE);
        KeyguardManager.KeyguardLock kl = km.newKeyguardLock("unLock");
        //解锁
        kl.disableKeyguard();
        //获取电源管理器对象
        PowerManager pm = (PowerManager) context.getSystemService(Context.POWER_SERVICE);
        //获取PowerManager.WakeLock对象,后面的参数|表示同时传入两个值,最后的是LogCat里用的Tag
        PowerManager.WakeLock wl = pm.newWakeLock(PowerManager.FULL_WAKE_LOCK | PowerManager.ACQUIRE_CAUSES_WAKEUP | PowerManager.ON_AFTER_RELEASE, "bright");
        //点亮屏幕
        wl.acquire();
        //释放
        wl.release();
    }

}
