package com.sanzeng.hello_watch.views;

import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.util.Log;
import android.view.View;
import android.widget.NumberPicker;

import com.sanzeng.hello_watch.R;

import java.util.Calendar;

/**
 * 时间选择器
 * Created by home on 2017/6/30.
 */
public class ShowDateDialog extends AlertDialog implements NumberPicker.OnValueChangeListener {

    private Context context;
    private String title;
    private NumberPicker np1, np2, np3;
    private int maxDay;
    private String time;

    public ShowDateDialog(Context context, String title) {
        super(context);
        this.context = context;
        this.title = title;
        initView();
    }

    private void initView() {
        View mView = View.inflate(context, R.layout.date_dialog, null);
        np1 = (NumberPicker) mView.findViewById(R.id.np1);
        np2 = (NumberPicker) mView.findViewById(R.id.np2);
        np3 = (NumberPicker) mView.findViewById(R.id.np3);
        np1.setOnValueChangedListener(this);
        np2.setOnValueChangedListener(this);
        np3.setOnValueChangedListener(this);
        //获取当前日期
        Calendar c = Calendar.getInstance();
        final int year = c.get(Calendar.YEAR);
        final int month = c.get(Calendar.MONTH) + 1;//月份是从0开始算的
        final int day = c.get(Calendar.DAY_OF_MONTH);

        //设置年份
        np1.setMaxValue(year);
        np1.setValue(year); //中间参数 设置默认值
        np1.setMinValue(1999);

        //设置月份
        np2.setMaxValue(12);
        np2.setValue(month);
        np2.setMinValue(1);

        //设置天数
        switch (month) {
            case 1:
            case 3:
            case 5:
            case 7:
            case 8:
            case 10:
            case 12:
                maxDay = 31;
                np3.setMaxValue(maxDay);
                break;

            default:
                maxDay = 30;
                np3.setMaxValue(maxDay);
                break;
        }
        np3.setValue(day);
        np3.setMinValue(1);

        new AlertDialog.Builder(context).setTitle(title)
                .setView(mView)
                .setPositiveButton("确定", new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {

                        if (onDateClickListener != null) {
                            int years = np1.getValue();
                            int months = np2.getValue();
                            int days = np3.getValue();
                            time = years + "-" + months + "-" + days;
                            onDateClickListener.onClickSureBtn(time);
                            dialog.dismiss();
                        }
                    }
                })
                .setNegativeButton("取消", new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        if (onDateClickListener != null) {
                            onDateClickListener.onClickCancelBtn();
                            dialog.dismiss();
                        }
                    }
                }).create();
    }

    @Override
    public void onValueChange(NumberPicker picker, int oldVal, int newVal) {
        switch (picker.getId()) {
            //年份滑动监听
            case R.id.np1:
                Log.i("NumberPicker", "oldVal-----" + oldVal + "-----newVal-----" + newVal);
                //平年闰年判断
                if (newVal % 4 == 0) {
                    maxDay = 29;
                } else {
                    maxDay = 28;
                }
                //设置天数的最大值
                np3.setMaxValue(maxDay);
                break;

            //月份滑动监听
            case R.id.np2:
                Log.i("NumberPicker", "oldVal-----" + oldVal + "-----newVal-----" + newVal);
                //月份判断
                switch (newVal) {
                    case 2:
                        if (np1.getValue() % 4 == 0) {
                            maxDay = 29;
                        } else {
                            maxDay = 28;
                        }
                        break;
                    case 1:
                    case 3:
                    case 5:
                    case 7:
                    case 8:
                    case 10:
                    case 12:
                        maxDay = 31;
                        break;
                    default:
                        maxDay = 30;
                        break;
                }
                //设置天数的最大值
                np3.setMaxValue(maxDay);
                break;
        }
    }

    private OnDateClickListener onDateClickListener;

    public void setOnDateClickListener(OnDateClickListener onDateClickListener) {
        this.onDateClickListener = onDateClickListener;
    }

    public interface OnDateClickListener {
        void onClickSureBtn(String time);

        void onClickCancelBtn();
    }
}
