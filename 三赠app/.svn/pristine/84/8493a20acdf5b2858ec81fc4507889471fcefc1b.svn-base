package com.sanzeng.hello_watch.views;

import android.content.Context;
import android.util.AttributeSet;
import android.widget.GridView;

/**
 * 解决滑动冲突
 * Created by YY on 2017/6/28.
 */
public class SureRoleGridView extends GridView {
    public SureRoleGridView(Context context) {
        super(context);
    }

    public SureRoleGridView(Context context, AttributeSet attrs) {
        super(context, attrs);
    }

    public SureRoleGridView(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
    }

    @Override
    protected void onMeasure(int widthMeasureSpec, int heightMeasureSpec) {
        int expandSpec = MeasureSpec.makeMeasureSpec(
                Integer.MAX_VALUE >> 2, MeasureSpec.AT_MOST);
        super.onMeasure(widthMeasureSpec, expandSpec);
    }
}
