package com.sanzeng.hello_watch.ui.activity.login;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.KeyEvent;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ImageView;

import com.sanzeng.hello_watch.R;
import com.sanzeng.hello_watch.ctr.RoleController;
import com.sanzeng.hello_watch.cts.AppConst;
import com.sanzeng.hello_watch.entity.SureRoleEntity;
import com.sanzeng.hello_watch.entity.SureRoleResponse;
import com.sanzeng.hello_watch.interfc.ResponseItf;
import com.sanzeng.hello_watch.ui.activity.MainActivity;
import com.sanzeng.hello_watch.ui.adapter.SureRoleAdapter;
import com.sanzeng.hello_watch.utils.NetworkUtil;
import com.sanzeng.hello_watch.utils.PfsUtils;
import com.sanzeng.hello_watch.utils.ProjectPfs;
import com.sanzeng.hello_watch.utils.ResponseCodeConfigs;
import com.sanzeng.hello_watch.utils.ViewUtils;
import com.sanzeng.hello_watch.views.LoadingDialog;
import com.sanzeng.hello_watch.views.SureRoleGridView;
import com.sanzeng.hello_watch.views.SystemExitDialog;

import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;

public class SureRoleActivity extends Activity {

    @BindView(R.id.gridView)
    SureRoleGridView gridView;

    @OnClick(R.id.family_icon_iv)
    void requestData() {
        if (NetworkUtil.isNetworkPass(this))
            getRoleData();
        else ViewUtils.showToast(this, getString(R.string.net_error));
    }

    //确认角色控制器
    private RoleController roleController;

    private SureRoleAdapter sureRoleAdapter;

    //角色列表
    private List<SureRoleEntity> roleEntityList;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_sure_role);
        ButterKnife.bind(this);
        initView();
        bizView();

    }

    private void bizView() {
        if (NetworkUtil.isNetworkPass(this))
            getRoleData();
        else ViewUtils.showToast(this, getString(R.string.net_error));
    }

    private void initView() {
        roleController = new RoleController();
        sureRoleAdapter = new SureRoleAdapter(this, R.layout.item_choice_persion);
        gridView.setAdapter(sureRoleAdapter);
        gridView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, final int position, long id) {
                final SystemExitDialog systemExitDialog=new SystemExitDialog(SureRoleActivity.this,getString(R.string.string_sure_role_tips));
                systemExitDialog.show();
                systemExitDialog.setOnClickSystemExitListener(new SystemExitDialog.OnClickSystemExitListener() {
                    @Override
                    public void onClickSystemExitSureBtn() {
                        systemExitDialog.dismiss();
                        sureRoleAdapter.setSelectPosition(position);
                        sureRoleAdapter.notifyDataSetChanged();
                        String roleType = roleEntityList.get(position).getRole_type();
                        PfsUtils.savePfs(ProjectPfs.PFS_SYS, AppConst.ROLE_TYPE, roleType);
                        if (NetworkUtil.isNetworkPass(SureRoleActivity.this))
                            commiteData(roleType);
                        else ViewUtils.showToast(SureRoleActivity.this, getString(R.string.net_error));
                    }

                    @Override
                    public void onClickCancelBtn() {
                        systemExitDialog.dismiss();
                    }
                });
            }
        });

    }
    /**
     * 提交数据
     */
    private void commiteData(String roleType) {
        final LoadingDialog loadingDialog = new LoadingDialog(this, "请稍等...");
        loadingDialog.show();
        roleController.commiteData(roleType, new ResponseItf<SureRoleResponse>() {
            @Override
            public void onError(int type) {
                loadingDialog.close();
                if (type == ResponseCodeConfigs.TYPE_NET_ERR) {
                    ViewUtils.showToast(SureRoleActivity.this, ResponseCodeConfigs.NET_ERROR);
                } else
                    ViewUtils.showToast(SureRoleActivity.this, ResponseCodeConfigs.SYSTEM_ERROR);
            }

            @Override
            public void onSuccess(SureRoleResponse sureRoleResponse) {
                loadingDialog.close();
                PfsUtils.savePfs(ProjectPfs.PFS_SYS, AppConst.CHOICE_PEOPLE, true);
                startActivity(new Intent(SureRoleActivity.this, MainActivity.class));
                finish();
            }

            @Override
            public void onFail(String str) {
                loadingDialog.close();
                ViewUtils.showToast(SureRoleActivity.this, str);
            }
        });
    }


    /**
     * 获取角色数据
     */
    private void getRoleData() {
        final LoadingDialog loadingDialog = new LoadingDialog(this, "加载中...");
        loadingDialog.show();
        roleController.getRoleData(new ResponseItf<SureRoleResponse>() {
            @Override
            public void onError(int type) {
                loadingDialog.close();
                if (type == ResponseCodeConfigs.TYPE_NET_ERR) {
                    ViewUtils.showToast(SureRoleActivity.this, ResponseCodeConfigs.NET_ERROR);
                } else
                    ViewUtils.showToast(SureRoleActivity.this, ResponseCodeConfigs.SYSTEM_ERROR);
            }

            @Override
            public void onSuccess(SureRoleResponse sureRoleResponse) {
                if (sureRoleResponse != null)
                    if (sureRoleResponse.getData() != null) {
                        roleEntityList = sureRoleResponse.getData();
                        sureRoleAdapter.replaceAll(roleEntityList);
                    }
                loadingDialog.close();
            }

            @Override
            public void onFail(String str) {
                loadingDialog.close();
                ViewUtils.showToast(SureRoleActivity.this, str);
            }

        });
    }

    @Override
    public boolean onKeyDown(int keyCode, KeyEvent event) {
        if (keyCode == KeyEvent.KEYCODE_BACK) {
            final SystemExitDialog systemExitDialog = new SystemExitDialog(SureRoleActivity.this, getString(R.string.string_sure_out_tips));
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
