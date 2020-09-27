package com.sanzeng.hello_watch.ctr;

import com.google.gson.Gson;
import com.sanzeng.hello_watch.cts.AppApi;
import com.sanzeng.hello_watch.cts.AppConst;
import com.sanzeng.hello_watch.entity.JoinFamilyResponse;
import com.sanzeng.hello_watch.entity.SureRoleResponse;
import com.sanzeng.hello_watch.interfc.ResponseItf;
import com.sanzeng.hello_watch.utils.CodeController;
import com.sanzeng.hello_watch.utils.PfsUtils;
import com.sanzeng.hello_watch.utils.ProjectPfs;
import com.sanzeng.hello_watch.utils.ResponseCodeConfigs;
import com.sanzeng.hello_watch.utils.TreatmentResult;
import com.zhy.http.okhttp.OkHttpUtils;
import com.zhy.http.okhttp.callback.StringCallback;

import java.io.UnsupportedEncodingException;
import java.net.SocketTimeoutException;
import java.net.URLEncoder;

import okhttp3.Call;

/**
 * 输入手环码控制器
 * Created by YY on 2017/6/14.
 */
public class RoleController {

    /**
     * 提交角色数据
     *
     * @param callback 回调
     */
    public void commiteData(String roleType, final ResponseItf<SureRoleResponse> callback) {
        String groupId = PfsUtils.readString(ProjectPfs.PFS_SYS, AppConst.WATCH_CODE);
        String province = PfsUtils.readString(ProjectPfs.PFS_SYS, AppConst.CURRENT_LOCATION);
        int deviceType = PfsUtils.readInteger(ProjectPfs.PFS_SYS, AppConst.DEVICE_TYPE);
        //手机码
        String person_id = PfsUtils.readString(ProjectPfs.PFS_SYS, AppConst.M_AUTH_ID);
        String channelId = PfsUtils.readString(ProjectPfs.PFS_SYS, AppConst.CHANNEL_ID);
        String url = AppApi.JOIN_FAMILY;
        try {
            OkHttpUtils.get()
                    .url(url)
                    .addParams("person_id", channelId)
                    .addParams("type", deviceType + "")
                    .addParams("name", roleType)
                    .addParams("area", URLEncoder.encode(province, "utf-8"))
                    .addParams("groupId", groupId)
                    .build()
                    .execute(new StringCallback() {
                        @Override
                        public void onError(Call call, Exception e, int id) {
                            if (e.getClass().equals(SocketTimeoutException.class)) {
                                callback.onError(ResponseCodeConfigs.TYPE_NET_ERR);
                            } else {
                                callback.onError(ResponseCodeConfigs.TYPE_SYS_ERR);
                            }
                        }

                        @Override
                        public void onResponse(String response, int id) {
                            Gson gson = new Gson();

                            // 得到对象
                            SureRoleResponse responseObj = gson.fromJson(response, SureRoleResponse.class);
                            String isResult = responseObj.isResult();
                            if (isResult.equals("success")) {
                                callback.onSuccess(responseObj);
                            }
                            if (isResult.equals("failed")) {
                                String msg = responseObj.getMsg();
                                callback.onFail(msg);
                            }
                        }
                    });
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }
    }


    /**
     * 获取角色数据
     *
     * @param callback 回调
     */
    public void getRoleData(final ResponseItf<SureRoleResponse> callback) {

        String groupId = PfsUtils.readString(ProjectPfs.PFS_SYS, AppConst.WATCH_CODE);

        String url = AppApi.GET_ROLE_LIST;
        OkHttpUtils.get()
                .url(url)
                .addParams("role_name", groupId)
                .build()
                .writeTimeOut(20000)
                .readTimeOut(20000)
                .connTimeOut(20000)
                .execute(new StringCallback() {
                    @Override
                    public void onError(Call call, Exception e, int id) {
                        if (e.getClass().equals(SocketTimeoutException.class)) {
                            callback.onError(ResponseCodeConfigs.TYPE_NET_ERR);
                        } else {
                            callback.onError(ResponseCodeConfigs.TYPE_SYS_ERR);
                        }
                    }

                    @Override
                    public void onResponse(String response, int id) {
                        Gson gson = new Gson();
                        // 得到对象
                        SureRoleResponse responseObj = gson.fromJson(response, SureRoleResponse.class);
                        String isResult = responseObj.isResult();
                        if (isResult.equals("success")) {
                            callback.onSuccess(responseObj);
                        } else callback.onError(ResponseCodeConfigs.TYPE_SYS_ERR);
                    }
                });
    }

}
