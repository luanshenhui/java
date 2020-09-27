package com.sanzeng.hello_watch.ui.activity;

import android.app.Activity;
import android.content.Intent;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.os.Bundle;
import android.os.CountDownTimer;
import android.os.Handler;
import android.util.Log;
import android.view.Gravity;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.view.animation.AlphaAnimation;
import android.view.animation.Animation;
import android.view.animation.AnimationSet;
import android.view.animation.AnimationUtils;
import android.view.animation.DecelerateInterpolator;
import android.view.animation.LinearInterpolator;
import android.view.animation.RotateAnimation;
import android.view.animation.TranslateAnimation;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.PopupWindow;
import android.widget.TextView;

import com.sanzeng.hello_watch.R;
import com.sanzeng.hello_watch.ctr.MainController;
import com.sanzeng.hello_watch.ctr.RoleController;
import com.sanzeng.hello_watch.cts.AppConst;
import com.sanzeng.hello_watch.entity.ColorTypeEntity;
import com.sanzeng.hello_watch.entity.ColorTypeItem;
import com.sanzeng.hello_watch.entity.InputDateResponse;
import com.sanzeng.hello_watch.entity.MainResponse;
import com.sanzeng.hello_watch.entity.PersonColorType;
import com.sanzeng.hello_watch.entity.SureRoleEntity;
import com.sanzeng.hello_watch.entity.SureRoleResponse;
import com.sanzeng.hello_watch.interfc.ResponseItf;
import com.sanzeng.hello_watch.ui.adapter.ColorTypeAdapter;
import com.sanzeng.hello_watch.utils.NetworkUtil;
import com.sanzeng.hello_watch.utils.PfsUtils;
import com.sanzeng.hello_watch.utils.ProjectPfs;
import com.sanzeng.hello_watch.utils.ResponseCodeConfigs;
import com.sanzeng.hello_watch.utils.ViewUtils;
import com.sanzeng.hello_watch.views.EasyWaveView;
import com.sanzeng.hello_watch.views.LoadingDialog;
import com.sanzeng.hello_watch.views.RingView;
import com.sanzeng.hello_watch.views.SystemExitDialog;
import com.sanzeng.hello_watch.views.exception.OnDrawingException;

import java.util.ArrayList;
import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;

public class MainActivity extends Activity implements View.OnClickListener {

    @BindView(R.id.easyWaveView)
    EasyWaveView easyWaveView;

    @BindView(R.id.ring_view)
    RingView ring_view;

    // 底部栏
    @BindView(R.id.goodDetailsBottom_Ll)
    LinearLayout goodDetailsBottom_Ll;

    @BindView(R.id.imageButton)
    ImageView imageButton;

    @BindView(R.id.count_down_timer)
    TextView count_down_timer;

    @OnClick(R.id.imageButton)
    void more() {
        showPw();
    }

    //光圈颜色集合
    private int[] color = {Color.RED, Color.GREEN, Color.BLUE};

    private int type = 0;

    private boolean longClicked = false;

    //帮助
    private View v;

    //使用方法
    TextView pop_use_details;

    //颜色注解
    ListView color_type_lv;

    //颜色注解总布局
    LinearLayout color_type_LL;

    //校验是否点击
    private boolean isClick, isColorType;

    //倒计时
    private CountDownTimer timer;

    //当前倒计时
    private long times;

    private int color1 = Color.rgb(0, 0, 0);
    private int color2 = Color.rgb(0, 0, 0);
    private int color3 = Color.rgb(0, 0, 0);

    private double r = 0;
    private double g = 0;
    private double b = 0;

    private MainController mainController;

    private ColorTypeAdapter colorTypeAdapter;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        setContentView(R.layout.activity_main);
        ButterKnife.bind(this);
        initViews();

    }

    private void initViews() {
        mainController = new MainController();
        //倒计时
        String time = PfsUtils.readString(ProjectPfs.PFS_SYS, AppConst.CURRENT_TIME);
        if (NetworkUtil.isNetworkPass(this)){
            getRoleData();
            if (time == null || time.equals("")) {
                getCountTime();
            } else startCountDownTime(Integer.valueOf(time));
        }
        else ViewUtils.showToast(this, getString(R.string.net_error));

        v = LayoutInflater.from(this).inflate(R.layout.popwindow_deposit, null);
        //使用方法
        TextView pop_use_tv = (TextView) v.findViewById(R.id.pop_use_tv);
        //使用说明
        pop_use_details = (TextView) v.findViewById(R.id.pop_use_details);
        color_type_LL = (LinearLayout) v.findViewById(R.id.color_type_LL);
        //颜色注解
        TextView pop_color_tv = (TextView) v.findViewById(R.id.pop_color_tv);
        color_type_lv = (ListView) v.findViewById(R.id.color_type_lv);
         colorTypeAdapter = new ColorTypeAdapter(this, R.layout.item_color_type_lv);
        color_type_lv.setAdapter(colorTypeAdapter);

        pop_use_tv.setOnClickListener(this);
        pop_color_tv.setOnClickListener(this);

        easyWaveView.setInterCircleColor(color[0]);
        easyWaveView.setOutCircleColor(color[0]);
        easyWaveView.setOnClickListener(this);
        easyWaveView.setOnTouchListener(new View.OnTouchListener() {
            @Override
            public boolean onTouch(View v, MotionEvent event) {
                if (event.getAction() == MotionEvent.ACTION_DOWN) {
                    //快进
                    changedColor();
                    longClicked = false;
//                    Toast.makeText(MainActivity.this, "松开飞出....", Toast.LENGTH_SHORT).show();
                } else if (event.getAction() == MotionEvent.ACTION_UP) {
                    longClicked = true;
                    onClick();
                    //初始化 Translate动画
                    TranslateAnimation translateAnimation = new TranslateAnimation(0f, 0f, 0f, -800.0f);
                    //初始化 Alpha动画
                    AlphaAnimation alphaAnimation = new AlphaAnimation(1.0f, 0.1f);
                    //动画集
                    AnimationSet set = new AnimationSet(true);
                    set.addAnimation(translateAnimation);
                    set.addAnimation(alphaAnimation);

                    //设置动画时间 (作用到每个动画)
                    set.setDuration(1000);
//                    easyWaveView.startAnimation(set);
                    if (NetworkUtil.isNetworkPass(MainActivity.this))
                        requestData();
                    else ViewUtils.showToast(MainActivity.this, getString(R.string.net_error));
                }

                return false;
            }
        });
    }

    private void onClick() {

        switch (type) {
            case 0:
                color1 = Color.rgb((int) r, 0, 0);
                if (r < 255) {
                    r = r + 25.5;
                }
                break;

            case 1:
                color2 = Color.rgb(0, (int) g, 0);
                if (g < 255) {
                    g = g + 25.5;
                }
                break;

            case 2:
                color3 = Color.rgb(0, 0, (int) b);
                if (b < 255) {
                    b = b + 25.5;
                }
                break;
        }

        int allColor = Color.rgb((int) r, (int) g, (int) b);
        easyWaveView.setInterCircleColor(allColor);
        easyWaveView.setOutCircleColor(allColor);
        ring_view.setColors(new int[]{allColor, color2, color3});
        ring_view.setValues(new int[]{1, 1, 1});
        try {
            ring_view.startDraw();
        } catch (OnDrawingException e) {
            e.printStackTrace();
        }

        Animation operatingAnim = AnimationUtils.loadAnimation(MainActivity.this, R.anim.rotate);
        LinearInterpolator lin = new LinearInterpolator();
        operatingAnim.setInterpolator(lin);
        ring_view.startAnimation(operatingAnim);
    }

    private void changedColor() {
        new Handler().post(new Runnable() {
            @Override
            public void run() {
                while (!longClicked) {
                    switch (type) {
                        case 0:
                            easyWaveView.setInterCircleColor(color[0]);
                            easyWaveView.setOutCircleColor(color[0]);
                            type = 1;
                            waite();
                            break;

                        case 1:
                            easyWaveView.setInterCircleColor(color[1]);
                            easyWaveView.setOutCircleColor(color[1]);
                            type = 2;
                            waite();
                            break;

                        case 2:
                            easyWaveView.setInterCircleColor(color[2]);
                            easyWaveView.setOutCircleColor(color[2]);
                            type = 0;
                            waite();
                            break;

                    }
                    break;
                }
            }
        });
    }

    private void waite() {
        new Handler().postDelayed(new Runnable() {
            @Override
            public void run() {
                changedColor();
            }
        }, 2000);
    }

    /**
     * 获取授权
     */
    private void requestData() {
        mainController.getRespons(String.valueOf(color[type]), new ResponseItf<MainResponse>() {
            @Override
            public void onError(int type) {
                if (type == ResponseCodeConfigs.TYPE_NET_ERR) {
                    ViewUtils.showToast(MainActivity.this, ResponseCodeConfigs.NET_ERROR);
                } else
                    ViewUtils.showToast(MainActivity.this, ResponseCodeConfigs.SYSTEM_ERROR);
            }

            @Override
            public void onSuccess(MainResponse mainResponse) {

            }

            @Override
            public void onFail(String str) {
                ViewUtils.showToast(MainActivity.this, str);
            }
        });
    }


    /**
     * 获取倒计时
     */
    private void getCountTime() {
        mainController.getCountTime(new ResponseItf<MainResponse>() {
            @Override
            public void onError(int type) {
                if (type == ResponseCodeConfigs.TYPE_NET_ERR) {
                    ViewUtils.showToast(MainActivity.this, ResponseCodeConfigs.NET_ERROR);
                } else
                    ViewUtils.showToast(MainActivity.this, ResponseCodeConfigs.SYSTEM_ERROR);
            }

            @Override
            public void onSuccess(MainResponse inputDateResponse) {
                //倒计时
                if (inputDateResponse.getData() != null && !inputDateResponse.getData().equals("")) {
                    String time = inputDateResponse.getData();
                    startCountDownTime(Integer.valueOf(time));
                }

            }

            @Override
            public void onFail(String str) {
                ViewUtils.showToast(MainActivity.this, str);
            }
        });
    }

    /**
     * 帮助菜单
     */
    private void showPw() {
        final PopupWindow pw = new PopupWindow(v, WindowManager.LayoutParams.MATCH_PARENT,
                WindowManager.LayoutParams.MATCH_PARENT);
//        Point size = new Point();

        /* 判断用户手机系统版本来使用不同的方法 */
//        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.HONEYCOMB_MR2) {
//            this.getWindowManager().getDefaultDisplay().getSize(size);
//            pw.setHeight((int) (size.y * 0.4));
//        } else {
//            Display display = getWindowManager().getDefaultDisplay();
//            pw.setHeight((int) (display.getHeight() * 0.4));
//        }

        final WindowManager.LayoutParams params = getWindow().getAttributes();
        params.alpha = 0.5f;
        getWindow().setAttributes(params);
        ColorDrawable dw = new ColorDrawable(0x33000000);
        pw.setBackgroundDrawable(dw);
        pw.setAnimationStyle(R.style.popup_anim_style);
        pw.setOutsideTouchable(true);
        pw.setFocusable(true);
        pw.showAsDropDown(imageButton);
        pw.setContentView(v);
        pw.showAtLocation(goodDetailsBottom_Ll, Gravity.CENTER_HORIZONTAL, 0, 0);
        pw.setOnDismissListener(new PopupWindow.OnDismissListener() {
            @Override
            public void onDismiss() {
                params.alpha = 1.0f;
                getWindow().setAttributes(params);
            }
        });
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.pop_use_tv:
                color_type_LL.setVisibility(View.GONE);
                if (isClick) {
                    pop_use_details.setVisibility(View.GONE);
                    isClick = false;
                } else {
                    pop_use_details.setVisibility(View.VISIBLE);
                    isClick = true;
                }
                break;

            case R.id.pop_color_tv:
                pop_use_details.setVisibility(View.GONE);
                if (isColorType) {
                    color_type_LL.setVisibility(View.GONE);
                    isColorType = false;
                } else {
                    color_type_LL.setVisibility(View.VISIBLE);
                    isColorType = true;
                }
                break;

            case R.id.easyWaveView:

                break;
        }
    }

    private void startCountDownTime(long time) {
        /**
         * 最简单的倒计时类，实现了官方的CountDownTimer类（没有特殊要求的话可以使用）
         * 即使退出activity，倒计时还能进行，因为是创建了后台的线程。
         * 有onTick，onFinsh、cancel和start方法
         */
        timer = new CountDownTimer(time * 1000, 1000) {
            @Override
            public void onTick(long millisUntilFinished) {
                //每隔countDownInterval秒会回调一次onTick()方法
                times = millisUntilFinished / 1000;
                if (times < 10)
                    count_down_timer.setText("0" + times);
                else count_down_timer.setText(times + "");
            }

            @Override
            public void onFinish() {
                count_down_timer.setText("0");
                Log.d("CountDownTime", "onFinish -- 倒计时结束");
            }
        };
        timer.start();// 开始计时

    }


    /**
     * 获取角色数据
     */
    private void getRoleData() {
        //确认角色控制器
        final LoadingDialog loadingDialog = new LoadingDialog(this, "加载中...");
        loadingDialog.show();
        mainController.getRoleData(new ResponseItf<ColorTypeEntity>() {
            @Override
            public void onError(int type) {
                loadingDialog.close();
                if (type == ResponseCodeConfigs.TYPE_NET_ERR) {
                    ViewUtils.showToast(MainActivity.this, ResponseCodeConfigs.NET_ERROR);
                } else
                    ViewUtils.showToast(MainActivity.this, ResponseCodeConfigs.SYSTEM_ERROR);
            }

            @Override
            public void onSuccess(ColorTypeEntity colorTypeEntity) {
                if (colorTypeEntity != null)
                    if (colorTypeEntity.getData() != null) {
                        List<PersonColorType> personColorTypes = colorTypeEntity.getData();
                        colorTypeAdapter.addAll(personColorTypes);

                    }
                loadingDialog.close();
            }

            @Override
            public void onFail(String str) {
                loadingDialog.close();
                ViewUtils.showToast(MainActivity.this, str);
            }

        });
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        if (timer != null)
            timer.cancel(); // 取消
    }

    @Override
    public boolean onKeyDown(int keyCode, KeyEvent event) {
        if (keyCode == KeyEvent.KEYCODE_BACK) {
            final SystemExitDialog systemExitDialog = new SystemExitDialog(MainActivity.this, getString(R.string.string_sure_out_tips));
            systemExitDialog.show();
            systemExitDialog.setOnClickSystemExitListener(new SystemExitDialog.OnClickSystemExitListener() {
                @Override
                public void onClickSystemExitSureBtn() {
                    systemExitDialog.dismiss();
                    String time = count_down_timer.getText().toString();
                    PfsUtils.savePfs(ProjectPfs.PFS_SYS, AppConst.CURRENT_TIME, time);
                    android.os.Process.killProcess(android.os.Process.myUid());
                    System.exit(0);
                }

                @Override
                public void onClickCancelBtn() {
                    systemExitDialog.dismiss();
                }
            });
        }
        return super.onKeyDown(keyCode, event);
    }
}
