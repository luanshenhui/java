package com.sanzeng.hello_watch.ui.activity.home;

import android.content.Intent;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;

import com.sanzeng.hello_watch.R;
import com.sanzeng.hello_watch.ui.activity.guide.HelpGuideActivity;

import butterknife.ButterKnife;
import butterknife.OnClick;

public class HelpActivity extends AppCompatActivity {

    @OnClick(R.id.back_btn)
    void back() {
        finish();
    }

    @OnClick(R.id.use_guide_btn)
    void useGuide() {
        startActivity(new Intent(HelpActivity.this, HelpGuideActivity.class));
    }

    @OnClick(R.id.color_guide_btn)
    void colorGuide() {

    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_help);
        ButterKnife.bind(this);
    }
}
