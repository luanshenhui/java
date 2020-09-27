package com.sanzeng.hello_watch.ui.adapter;

import android.content.Context;

import com.sanzeng.hello_watch.R;
import com.sanzeng.hello_watch.entity.ColorTypeEntity;
import com.sanzeng.hello_watch.entity.ColorTypeItem;
import com.sanzeng.hello_watch.entity.PersonColorType;
import com.sanzeng.hello_watch.entity.SureRoleEntity;
import com.sanzeng.hello_watch.views.SureRoleGridView;

import java.util.List;

/**
 * 颜色类型适配器
 * Created by home on 2017/6/19.
 */
public class ColorTypeAdapter extends QuickAdapter<PersonColorType> {

    private SureRoleGridView color_type_gv;

    private ColorTypeGvAdapter colorTypeGvAdapter;

    private Context context;

    public ColorTypeAdapter(Context context, int layoutResId) {
        super(context, layoutResId);
        this.context = context;
    }

    public ColorTypeAdapter(Context context, int layoutResId, List<PersonColorType> data) {
        super(context, layoutResId, data);
    }

    @Override
    protected void convert(BaseAdapterHelper helper, PersonColorType item) {
            color_type_gv = helper.getView(R.id.color_type_gv);
            helper.setText(R.id.color_type_name, item.getName());
        if (item.getTypeList() != null) {
            List<ColorTypeItem> typeList = item.getTypeList();
            colorTypeGvAdapter = new ColorTypeGvAdapter(context, R.layout.item_color_type_intro);
            color_type_gv.setAdapter(colorTypeGvAdapter);
            colorTypeGvAdapter.addAll(typeList);
        }
    }
}
