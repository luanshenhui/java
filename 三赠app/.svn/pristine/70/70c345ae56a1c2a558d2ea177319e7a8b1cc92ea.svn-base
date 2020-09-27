package com.sanzeng.hello_watch.ui.activity.register;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.NumberPicker;
import android.widget.TextView;

import com.sanzeng.hello_watch.R;
import com.sanzeng.hello_watch.ctr.InputDateController;
import com.sanzeng.hello_watch.cts.AppConst;
import com.sanzeng.hello_watch.entity.InputDateResponse;
import com.sanzeng.hello_watch.entity.SureRoleResponse;
import com.sanzeng.hello_watch.interfc.ResponseItf;
import com.sanzeng.hello_watch.ui.activity.MainActivity;
import com.sanzeng.hello_watch.utils.NetworkUtil;
import com.sanzeng.hello_watch.utils.PfsUtils;
import com.sanzeng.hello_watch.utils.ProjectPfs;
import com.sanzeng.hello_watch.utils.ResponseCodeConfigs;
import com.sanzeng.hello_watch.utils.ViewUtils;
import com.sanzeng.hello_watch.views.LoadingDialog;
import com.sanzeng.hello_watch.views.ShowDateDialog;

import java.util.Calendar;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;

public class InputDateActivity extends Activity {

    @BindView(R.id.input_birthday)
    TextView input_birthday;

    @OnClick(R.id.input_birthday)
    void showDailog() {
        showDateDialog();
    }

    @OnClick(R.id.yes)
    void yes() {

        if (time.equals("")) {
            ViewUtils.showToast(this, getString(R.string.string_plz_input_birth));
            return;
        }

        if (NetworkUtil.isNetworkPass(this)) {
            String roleType = "a";
            PfsUtils.savePfs(ProjectPfs.PFS_SYS, AppConst.ROLE_TYPE, roleType);
            commiteData(roleType, time);
        } else ViewUtils.showToast(this, getString(R.string.net_error));
    }

    @OnClick(R.id.no)
    void no() {
        finish();
    }

    private InputDateController inputDateController;

    private NumberPicker np1, np2, np3;
    private int maxDay;
    private String time;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_input_date);
        ButterKnife.bind(this);
        inputDateController = new InputDateController();
    }

    /**
     * 提交数据
     */
    private void commiteData(String roleType, String strYears) {
        final LoadingDialog loadingDialog = new LoadingDialog(this, "提交中...");
        loadingDialog.show();
        inputDateController.commiteData(roleType, strYears, new ResponseItf<InputDateResponse>() {
            @Override
            public void onError(int type) {
                loadingDialog.close();
                if (type == ResponseCodeConfigs.TYPE_NET_ERR) {
                    ViewUtils.showToast(InputDateActivity.this, ResponseCodeConfigs.NET_ERROR);
                } else
                    ViewUtils.showToast(InputDateActivity.this, ResponseCodeConfigs.SYSTEM_ERROR);
            }

            @Override
            public void onSuccess(InputDateResponse inputDateResponse) {
                loadingDialog.close();
                PfsUtils.savePfs(ProjectPfs.PFS_SYS, AppConst.BIRTHDAY, true);
                startActivity(new Intent(InputDateActivity.this, MainActivity.class));
                finish();
            }

            @Override
            public void onFail(String str) {
                loadingDialog.close();
                ViewUtils.showToast(InputDateActivity.this, str);
            }
        });
    }


    /**
     * 选择出生年月日
     */
    public void showDateDialog() {
        View mView = View.inflate(this, R.layout.date_dialog, null);
        np1 = (NumberPicker) mView.findViewById(R.id.np1);
        np2 = (NumberPicker) mView.findViewById(R.id.np2);
        np3 = (NumberPicker) mView.findViewById(R.id.np3);

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

        //年份滑动监听
        np1.setOnValueChangedListener(new NumberPicker.OnValueChangeListener() {
            @Override
            public void onValueChange(NumberPicker picker, int oldVal, int newVal) {
                Log.i("NumberPicker", "oldVal-----" + oldVal + "-----newVal-----" + newVal);
                //平年闰年判断
                if (newVal % 4 == 0) {
                    maxDay = 29;
                } else {
                    maxDay = 28;
                }
                //设置天数的最大值
                np3.setMaxValue(maxDay);
            }
        });

        //月份滑动监听
        np2.setOnValueChangedListener(new NumberPicker.OnValueChangeListener() {
            @Override
            public void onValueChange(NumberPicker picker, int oldVal, int newVal) {
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
            }
        });

        new AlertDialog.Builder(InputDateActivity.this).setTitle("请选择时间")
                .setView(mView)
                .setPositiveButton("确定", new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        int years = np1.getValue();
                        int months = np2.getValue();
                        int days = np3.getValue();
                        String month;
                        String day;
                        if (months < 10) {
                            month = "0" + months;
                        } else month = "" + months;
                        if (days < 10) {
                            day = "0" + days;
                        } else day = "" + days;
                        time = years + "-" + month + "-" + day;
                        input_birthday.setText(years + "年" + month + "月" + day + "日");
                        dialog.dismiss();
                    }
                })
                .setNegativeButton("取消", new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        dialog.dismiss();
                    }
                })
                .show();
    }
}
