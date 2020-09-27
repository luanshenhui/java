package com.sanzeng.hello_watch.ui.adapter;

import android.content.Context;
import android.graphics.Color;
import android.view.View;
import android.widget.ImageView;
import android.widget.SimpleAdapter;
import android.widget.TextView;

import com.sanzeng.hello_watch.R;
import com.sanzeng.hello_watch.entity.SureRoleEntity;

import java.util.List;
import java.util.Map;

/**
 * 角色适配器
 * Created by home on 2017/6/19.
 */
public class SureRoleAdapter extends QuickAdapter<SureRoleEntity> {

    // 图片封装为一个数组
    private int[] icon = {R.mipmap.bb, R.mipmap.mm, R.mipmap.yy, R.mipmap.nn, R.mipmap.wg, R.mipmap.wp,R.mipmap.bb, R.mipmap.mm, R.mipmap.yy, R.mipmap.nn, R.mipmap.wg, R.mipmap.wp};

    // 图片封装为一个数组
    private int[] icon_press = {R.mipmap.bb2, R.mipmap.mm2, R.mipmap.yy2, R.mipmap.nn2, R.mipmap.wg2, R.mipmap.wp2, R.mipmap.bb2, R.mipmap.mm2, R.mipmap.yy2, R.mipmap.nn2, R.mipmap.wg2, R.mipmap.wp2};

    private ImageView image;

    private TextView text;

    private int clickItemPosition = -1;

//标识选中的item

    public void setSelectPosition(int position) {
        clickItemPosition = position;
    }

    public SureRoleAdapter(Context context, int layoutResId) {
        super(context, layoutResId);
    }

    public SureRoleAdapter(Context context, int layoutResId, List<SureRoleEntity> data) {
        super(context, layoutResId, data);
    }

    @Override
    protected void convert(final BaseAdapterHelper helper, SureRoleEntity item) {
        helper.setText(R.id.text, item.getRole_name());
        image = helper.getView(R.id.image);
        text = helper.getView(R.id.text);
        try {
            image.setImageResource(icon[helper.getPosition()]);
        } catch (IndexOutOfBoundsException e) {
            e.printStackTrace();
        }
//        if (clickItemPosition == helper.getPosition()) {
//            image.setImageResource(icon_press[clickItemPosition]);
//            text.setTextColor(context.getResources().getColor(R.color.pressColor));
//        } else {
//            image.setImageResource(icon[clickItemPosition]);
//            text.setTextColor(context.getResources().getColor(R.color.normalColor));
//        }
    }
}
