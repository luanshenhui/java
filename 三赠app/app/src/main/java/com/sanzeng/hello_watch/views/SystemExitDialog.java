package com.sanzeng.hello_watch.views;

import android.app.Dialog;
import android.content.Context;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.TextView;

import com.sanzeng.hello_watch.R;
import com.sanzeng.hello_watch.utils.PfsUtils;
import com.sanzeng.hello_watch.utils.ProjectPfs;


/**
 * *取消确定 两个选择按钮的弹窗
 * 1.点击退出登录申请时
 * Created by YuYang on 2016/7/28.
 */
public class SystemExitDialog extends Dialog {
    private String resStr;

    public SystemExitDialog(Context context, String resStr) {
        super(context, R.style.BigPhototDialog);
        this.resStr = resStr;
        init();
    }

    private void init() {
        setContentView(R.layout.dialog_sys_exit);
        TextView dialog_cancelTV = (TextView) findViewById(R.id.sys_up_cancelTV);
        TextView dialog_sureTV = (TextView) findViewById(R.id.sys_up_sureTV);
        TextView dialog_gutTV = (TextView) findViewById(R.id.sys_gutTV);
        dialog_gutTV.setText(resStr);
        dialog_sureTV.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if (null != systemExitListener) {
                    systemExitListener.onClickSystemExitSureBtn();
                }
            }
        });
        dialog_cancelTV.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if (null != systemExitListener) {
                    systemExitListener.onClickCancelBtn();
                }
            }
        });
        int wid = PfsUtils.readInteger(ProjectPfs.PFS_SYS, ProjectPfs.SCREEN_WID);

        Window window = getWindow();
        WindowManager.LayoutParams params = window.getAttributes();
        params.width = ((wid / 4) * 3);
        params.height = ((wid / 8) * 3);
        window.setAttributes(params);
    }

    private OnClickSystemExitListener systemExitListener;

    public void setOnClickSystemExitListener(OnClickSystemExitListener systemExitListener) {
        this.systemExitListener = systemExitListener;
    }

    public interface OnClickSystemExitListener {
        void onClickSystemExitSureBtn();
        void onClickCancelBtn();
    }

}
