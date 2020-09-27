package com.example.schedule;

import android.app.AlarmManager;
import android.app.PendingIntent;
import android.app.Service;
import android.content.ComponentName;
import android.content.Intent;
import android.content.ServiceConnection;
import android.os.Handler;
import android.os.IBinder;
import android.os.SystemClock;

import java.util.Random;
import java.util.Timer;
import java.util.TimerTask;

public class MyService extends Service {

    private Runnable runnable;
    private Handler handler;
    private int Time = 1000*3;//周期时间
    private int anHour =8*60*60*1000;// 这是8小时的毫秒数 为了少消耗流量和电量，8小时自动更新一次
    private Timer timer = new Timer();
    @Override
    public IBinder onBind(Intent intent) {
        // TODO Auto-generated method stub
        return null;
    }

    @Override
    public void onCreate() {
        super.onCreate();
        /**
         * 方式一：采用Handler的postDelayed(Runnable, long)方法
         */
        handler = new Handler();
        runnable = new Runnable() {

            @Override
            public void run() {
                // handler自带方法实现定时器
                System.out.println("33331");
                handler.postDelayed(this, 1000*3);//每隔3s执行

            }
        };
        handler.postDelayed(runnable, 1000*60);//延时多长时间启动定时器

        /**
         * 方式二：采用timer及TimerTask结合的方法
         */
        TimerTask timerTask = new TimerTask() {
            @Override
            public void run() {
                System.out.println("99999998");
            }
        };
        timer.schedule(timerTask,
                1000,//延迟1秒执行
                Time);//周期时间


    }
    /**
     * 方式三：采用AlarmManager机制
     */
    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        /*new Thread(new Runnable() {

            @Override
            public void run() {
                System.out.println("99999988");//这是定时所执行的任务
            }
        }).start();
        AlarmManager manager = (AlarmManager) getSystemService(ALARM_SERVICE);
        long triggerAtTime = SystemClock.elapsedRealtime() + anHour;
        Intent intent2 = new Intent(this, AutoUpdateReceiver.class);
        PendingIntent pi = PendingIntent.getBroadcast(this, 0, intent2, 0);
        manager.set(AlarmManager.ELAPSED_REALTIME_WAKEUP, triggerAtTime, pi);*/
        return super.onStartCommand(intent, flags, startId);
    }

    @Override
    public void onDestroy() {
        super.onDestroy();

    }


}