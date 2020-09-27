package com.sanzeng.hello_watch.ui.adapter;

import android.content.Context;
import android.widget.ImageView;

import com.sanzeng.hello_watch.R;
import com.sanzeng.hello_watch.cts.AppApi;
import com.sanzeng.hello_watch.entity.ColorTypeEntity;
import com.sanzeng.hello_watch.entity.ColorTypeItem;
import com.sanzeng.hello_watch.entity.SureRoleEntity;
import com.squareup.picasso.Picasso;

import java.util.List;

/**
 * 颜色item介绍适配器
 * Created by home on 2017/6/19.
 */
public class ColorTypeGvAdapter extends QuickAdapter<ColorTypeItem> {


    public ColorTypeGvAdapter(Context context, int layoutResId) {
        super(context, layoutResId);
    }

    public ColorTypeGvAdapter(Context context, int layoutResId, List<ColorTypeItem> data) {
        super(context, layoutResId, data);
    }

    @Override
    protected void convert(BaseAdapterHelper helper, ColorTypeItem item) {

        helper.setText(R.id.color_intro_tv, item.getItemName());
        Picasso.with(context)
                .load(AppApi.API_HEAD +item.getItemColor())
                .noFade()
                .into((ImageView) helper.getView(R.id.color_intro_iv));
    }
}
