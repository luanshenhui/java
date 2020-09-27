package com.sanzeng.hello_watch.ui;

import android.app.Application;

import com.baidu.android.pushservice.PushConstants;
import com.baidu.android.pushservice.PushManager;
import com.iflytek.cloud.SpeechUtility;
import com.sanzeng.hello_watch.R;
import com.sanzeng.hello_watch.utils.PfsUtils;
import com.zhy.http.okhttp.OkHttpUtils;
import com.zhy.http.okhttp.cookie.CookieJarImpl;
import com.zhy.http.okhttp.cookie.store.PersistentCookieStore;

import java.util.concurrent.TimeUnit;

import okhttp3.OkHttpClient;

/**
 * application
 * Created by YY on 2017/6/12.
 */
public class HwApplication extends Application {

    private static HwApplication instance;

    public static HwApplication getInstance() {
        return instance;
    }

    @Override
    public void onCreate() {
        super.onCreate();
        instance = this;

        // 应用程序入口处调用,避免手机内存过小，杀死后台进程,造成SpeechUtility对象为null
        // 设置你申请的应用appid
        SpeechUtility.createUtility(this, "appid=" + getString(R.string.app_id));

        //缓存初始化
        PfsUtils.init(this);
        // Cookie配置
        CookieJarImpl cookieJar = new CookieJarImpl(new PersistentCookieStore(getApplicationContext()));

        // 网络请求组件初始化部分。
        OkHttpClient okHttpClient = new OkHttpClient.Builder()
                .connectTimeout(10000L, TimeUnit.MILLISECONDS)
                .readTimeout(10000L, TimeUnit.MILLISECONDS)
                .cookieJar(cookieJar)
                .build();

        OkHttpUtils.initClient(okHttpClient);

    }

    @Override
    public void onTerminate() {
        super.onTerminate();

        // 释放引用，等待GC回收。
        PfsUtils.dispose();
    }
}
