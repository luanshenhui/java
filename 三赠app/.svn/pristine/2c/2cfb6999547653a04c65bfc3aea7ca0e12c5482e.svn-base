package com.sanzeng.hello_watch.base;

import android.app.Activity;
import android.os.Bundle;
import android.os.PersistableBundle;
import android.view.KeyEvent;

import com.sanzeng.hello_watch.views.LoadingDialog;

/**
 * activity统一管理类
 * Created by YY on 2017/6/12.
 */
public abstract class BaseActivity extends Activity {

    @Override
    public void onCreate(Bundle savedInstanceState, PersistableBundle persistentState) {
        super.onCreate(savedInstanceState, persistentState);

        initViews();
        renderViews();
    }

    /**
     * 初始化视图
     */
    protected abstract void initViews();

    /**
     * 渲染控件
     */
    protected abstract void renderViews();


    @Override
    protected void onRestart() {
        super.onRestart();
    }

    @Override
    protected void onResume() {
        super.onResume();
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
    }

    @Override
    public boolean onKeyDown(int keyCode, KeyEvent event) {
        if (keyCode == KeyEvent.KEYCODE_BACK) {

        }
        return super.onKeyDown(keyCode, event);
    }
}
