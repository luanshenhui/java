package com.sanzeng.hello_watch.ui.adapter;

import android.os.Parcelable;
import android.support.v4.view.PagerAdapter;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;


import com.sanzeng.hello_watch.R;

import java.util.List;

/**
 * 引导页适配器
 * 第三张图片添加开始使用的按钮
 * Created by ge on 2016/6/30.
 */
public class IntroduceAdapter extends PagerAdapter {

    // 界面列表
    private List<View> views;

    public IntroduceAdapter(List<View> views) {
        this.views = views;
    }

    // 销毁arg1位置的界面
    @Override
    public void destroyItem(ViewGroup container, int position, Object object) {
//        super.destroyItem(container, position, object);//注掉原因  v4报下处理会造成程序崩溃
        container.removeView((View) object);
    }


    // 获得当前界面数
    @Override
    public int getCount() {
        if (views != null) {
            return views.size();
        }
        return 0;
    }

    // 初始化arg1位置的界面
    @Override
    public Object instantiateItem(ViewGroup arg0, int arg1) {
        arg0.addView(views.get(arg1), 0);
        if (arg1 == views.size() - 1) {
            Button startUseBtn = (Button) arg0.findViewById(R.id.startUseBtn);
            startUseBtn.setOnClickListener(new View.OnClickListener() {

                @Override
                public void onClick(View v) {
                    // 设置已经引导
                    setGuided();
                    if (onStartUseBtnListener != null) {
                        onStartUseBtnListener.onStartBtnClick(v);
                    }
                }

            });
        }
        return views.get(arg1);
    }


    /**
     * 设置已经引导过了，下次启动不用再次引导
     */
    private void setGuided() {

    }

    // 判断是否由对象生成界面
    @Override
    public boolean isViewFromObject(View arg0, Object arg1) {
        return (arg0 == arg1);
    }

    @Override
    public void restoreState(Parcelable arg0, ClassLoader arg1) {
    }

    @Override
    public Parcelable saveState() {
        return null;
    }

    //点击开始使用接口回调
    private OnStartUseBtnListener onStartUseBtnListener;

    public void setOnStartUseBtnListener(OnStartUseBtnListener onStartUseBtnListener) {
        this.onStartUseBtnListener = onStartUseBtnListener;
    }

    public interface OnStartUseBtnListener {
        void onStartBtnClick(View view);
    }


}
