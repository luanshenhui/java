package com.sanzeng.hello_watch.ui.activity.guide;

import android.content.Intent;
import android.os.Build;
import android.os.Bundle;
import android.support.v4.view.ViewPager;
import android.support.v7.app.AppCompatActivity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.WindowManager;

import com.sanzeng.hello_watch.R;
import com.sanzeng.hello_watch.cts.AppConst;
import com.sanzeng.hello_watch.ui.activity.register.RegisterActivity;
import com.sanzeng.hello_watch.ui.adapter.IntroduceAdapter;
import com.sanzeng.hello_watch.utils.PfsUtils;
import com.sanzeng.hello_watch.utils.ProjectPfs;
import com.sanzeng.hello_watch.views.CircleIndicator;

import java.util.ArrayList;
import java.util.List;

public class HelpGuideActivity extends AppCompatActivity {

    private ViewPager viewpager;
    private CircleIndicator indicatorCI;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_guide);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
            getWindow().addFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS);

            viewpager = (ViewPager) findViewById(R.id.viewpager);
            indicatorCI = (CircleIndicator) findViewById(R.id.indicatorCI);

            LayoutInflater inflater = LayoutInflater.from(this);
            List<View> views = new ArrayList<>();
            // 初始化引导图片列表
            views.add(inflater.inflate(R.layout.guide_img_one, null));
            views.add(inflater.inflate(R.layout.guide_img_two, null));
            // 初始化Adapter
            IntroduceAdapter vpAdapter = new IntroduceAdapter(views);

            vpAdapter.setOnStartUseBtnListener(new IntroduceAdapter.OnStartUseBtnListener() {
                @Override
                public void onStartBtnClick(View view) {
                    switch (view.getId()) {
                        case R.id.startUseBtn://开始使用
                            finish();
                            break;
                    }
                }
            });

            viewpager.setAdapter(vpAdapter);
            indicatorCI.setViewPager(viewpager);
            viewpager.setCurrentItem(0);
        }
    }
}
