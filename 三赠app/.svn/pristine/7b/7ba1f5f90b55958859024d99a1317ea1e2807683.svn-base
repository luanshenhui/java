package com.sanzeng.hello_watch.ui.activity.login;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.KeyEvent;
import android.widget.EditText;

import com.sanzeng.hello_watch.R;
import com.sanzeng.hello_watch.ctr.JoinFamilyController;
import com.sanzeng.hello_watch.cts.AppConst;
import com.sanzeng.hello_watch.entity.JoinFamilyResponse;
import com.sanzeng.hello_watch.entity.SureRoleResponse;
import com.sanzeng.hello_watch.interfc.ResponseItf;
import com.sanzeng.hello_watch.ui.activity.MainActivity;
import com.sanzeng.hello_watch.utils.PfsUtils;
import com.sanzeng.hello_watch.utils.ProjectPfs;
import com.sanzeng.hello_watch.utils.ResponseCodeConfigs;
import com.sanzeng.hello_watch.utils.ViewUtils;
import com.sanzeng.hello_watch.views.LoadingDialog;
import com.sanzeng.hello_watch.views.SystemExitDialog;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;

public class JoinFamilyActivity extends Activity {

    @OnClick(R.id.yes)
    void yes() {
        String inputStr = hand_watch_et.getText().toString().trim();

        // 过滤掉不合法的用户名
        if (TextUtils.isEmpty(inputStr)) {
            ViewUtils.showToast(this, "请输入手环身份号码");
            return;
        } else {
            Pattern p = Pattern.compile("[\u4e00-\u9fa5]");
            Matcher m = p.matcher(inputStr);
            if (m.find()) {
                ViewUtils.showToast(this, "不支持中文字符");
                return;
            } else if (inputStr.contains(" ")) {
                ViewUtils.showToast(this, "不能包含空格");
                return;
            }
//            } else if (!inputStr.matches("^[a-zA-Z][a-zA-Z0-9_]{5,17}")) {
//                ViewUtils.showToast(this, "6-18个字母、数字或下划线的组合，以字母开头");
//                return;
//            }
        }
        commiteData(inputStr);
    }

    @OnClick(R.id.no)
    void no() {
        finish();
    }

    @BindView(R.id.hand_watch_et)
    EditText hand_watch_et;

    private JoinFamilyController joinFamilyController;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_join_family);
        ButterKnife.bind(this);
    }


    /**
     * 提交数据
     */
    private void commiteData(final String inputStr) {
        joinFamilyController = new JoinFamilyController();
        final LoadingDialog loadingDialog = new LoadingDialog(this, "请稍等...");
        loadingDialog.show();
        joinFamilyController.commiteData(inputStr, new ResponseItf<JoinFamilyResponse>() {
            @Override
            public void onError(int type) {
                loadingDialog.close();
                if (type == ResponseCodeConfigs.TYPE_NET_ERR) {
                    ViewUtils.showToast(JoinFamilyActivity.this, ResponseCodeConfigs.NET_ERROR);
                } else
                    ViewUtils.showToast(JoinFamilyActivity.this, ResponseCodeConfigs.SYSTEM_ERROR);
            }

            @Override
            public void onSuccess(JoinFamilyResponse joinFamilyResponse) {
                loadingDialog.close();
                PfsUtils.savePfs(ProjectPfs.PFS_SYS, AppConst.WATCH_CODE, inputStr);
                startActivity(new Intent(JoinFamilyActivity.this, SureRoleActivity.class));
                finish();
            }

            @Override
            public void onFail(String str) {
                loadingDialog.close();
                ViewUtils.showToast(JoinFamilyActivity.this, str);
            }
        });
    }

    @Override
    public boolean onKeyDown(int keyCode, KeyEvent event) {
        if (keyCode == KeyEvent.KEYCODE_BACK) {
            final SystemExitDialog systemExitDialog = new SystemExitDialog(JoinFamilyActivity.this, getString(R.string.string_sure_out_tips));
            systemExitDialog.show();
            systemExitDialog.setOnClickSystemExitListener(new SystemExitDialog.OnClickSystemExitListener() {
                @Override
                public void onClickSystemExitSureBtn() {
                    systemExitDialog.dismiss();
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
