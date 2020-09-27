package com.sanzeng.hello_watch.ui.activity.guide;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.view.Window;
import android.widget.ImageView;


import com.baidu.android.pushservice.PushConstants;
import com.baidu.android.pushservice.PushManager;
import com.sanzeng.hello_watch.R;
import com.sanzeng.hello_watch.cts.AppConst;
import com.sanzeng.hello_watch.cts.UrlConst;
import com.sanzeng.hello_watch.ui.activity.register.RegisterActivity;
import com.sanzeng.hello_watch.ui.service.WakeUpService;
import com.sanzeng.hello_watch.utils.PfsUtils;
import com.sanzeng.hello_watch.utils.ProjectPfs;

import java.lang.ref.WeakReference;

import butterknife.BindView;
import butterknife.ButterKnife;


/**
 * Created by ZY on 2016/6/28.
 * APP启动页
 * 1.创建appRecorder对象
 */

public class AppStartActivity extends Activity {
    @BindView(R.id.start_Iv)
    ImageView start_Iv;

    private JumpHandler handler;

    private Runnable runnable = new Runnable() {

        @Override
        public void run() {
            //启动服务
            Intent intent = new Intent(AppStartActivity.this, WakeUpService.class);
            startService(intent);

            boolean flag = PfsUtils.readBoolean(ProjectPfs.PFS_SYS, AppConst.FIRST_VIEW);
            if (flag) {
                startActivity(new Intent(AppStartActivity.this, RegisterActivity.class));
            } else
                startActivity(new Intent(AppStartActivity.this, GuideActivity.class));

            overridePendingTransition(android.R.anim.fade_in,
                    android.R.anim.fade_out);
        }
    };


//    设备类型 1:手环  2：手机
    private int deviceType = 2;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        setContentView(R.layout.activity_appstart);

        //BaiDu----Push
        PushManager.startWork(getApplicationContext(), PushConstants.LOGIN_TYPE_API_KEY, UrlConst.API_KEY);

        PfsUtils.savePfs(ProjectPfs.PFS_SYS,AppConst.DEVICE_TYPE,deviceType);
        if ((getIntent().getFlags() & Intent.FLAG_ACTIVITY_BROUGHT_TO_FRONT) != 0) {
            finish();
            return;
        }
        initView();
    }

    protected void initView() {
        ButterKnife.bind(this);
        handler = new JumpHandler(this);
        // 1.5秒后跳转
        handler.postDelayed(runnable, 1500);
    }


    private static class JumpHandler extends Handler {
        WeakReference<AppStartActivity> mActivityReference;

        JumpHandler(AppStartActivity activity) {
            mActivityReference = new WeakReference<>(activity);
        }
    }


    @Override
    protected void onDestroy() {
        if (handler != null)
            if (runnable != null)
                handler.removeCallbacks(runnable);
        super.onDestroy();
    }

}
