package com.sanzeng.hello_watch.ctr;

import com.google.gson.Gson;
import com.sanzeng.hello_watch.cts.AppApi;
import com.sanzeng.hello_watch.cts.AppConst;
import com.sanzeng.hello_watch.cts.UrlConst;
import com.sanzeng.hello_watch.entity.ColorTypeEntity;
import com.sanzeng.hello_watch.entity.MainResponse;
import com.sanzeng.hello_watch.entity.SureRoleResponse;
import com.sanzeng.hello_watch.interfc.ResponseItf;
import com.sanzeng.hello_watch.utils.CodeController;
import com.sanzeng.hello_watch.utils.PfsUtils;
import com.sanzeng.hello_watch.utils.ProjectPfs;
import com.sanzeng.hello_watch.utils.ResponseCodeConfigs;
import com.sanzeng.hello_watch.utils.TreatmentResult;
import com.zhy.http.okhttp.OkHttpUtils;
import com.zhy.http.okhttp.callback.StringCallback;

import java.net.SocketTimeoutException;

import okhttp3.Call;

/**
 * 请求接口帮助控制器
 * Created by YY on 2017/6/14.
 */
public class MainController {

    /**
     * 发送颜色
     *
     * @param color    颜色
     * @param callback 回调
     */
    public void getRespons(String color, final ResponseItf<MainResponse> callback) {
        String inputStr = PfsUtils.readString(ProjectPfs.PFS_SYS, AppConst.WATCH_CODE);
        String roleType = PfsUtils.readString(ProjectPfs.PFS_SYS, AppConst.ROLE_TYPE);
        String url = AppApi.SYS_RES;
        OkHttpUtils.get()
                .url(url)
                .addParams("person_id", inputStr)
                .addParams("role_type", roleType)
                .addParams("c_?", color)
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
                        MainResponse responseObj = gson.fromJson(response, MainResponse.class);
                        String isResult = responseObj.getResult();
                        if (isResult.equals("success")) {
                            callback.onSuccess(responseObj);
                        }

                        if (isResult.equals("failed")) {
                            String msg = responseObj.getMsg();
                            callback.onFail(msg);
                        }
                    }
                });
    }

    /**
     * 获取倒计时
     * @param callback 回调
     */
    public void getCountTime(final ResponseItf<MainResponse> callback) {
        String url = AppApi.GET_LEAVE_TIME;
        int deviceType = PfsUtils.readInteger(ProjectPfs.PFS_SYS, AppConst.DEVICE_TYPE);
        String code;
        //    设备类型 1:手环  2：手机
        if (deviceType==1){
            //手机码
             code=PfsUtils.readString(ProjectPfs.PFS_SYS, AppConst.M_AUTH_ID);
        }else {
            //手机码
             code = PfsUtils.readString(ProjectPfs.PFS_SYS, AppConst.WATCH_CODE);
        }

        OkHttpUtils.get()
                .url(url)
                .addParams("clentId", code)
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
                        MainResponse responseObj = gson.fromJson(response, MainResponse.class);
                        String isResult = responseObj.getResult();
                        if (isResult.equals("success")) {
                            callback.onSuccess(responseObj);
                        }

                        if (isResult.equals("failed")) {
                            String msg = responseObj.getMsg();
                            callback.onFail(msg);
                        }
                    }
                });
    }


    /**
     * 获取角色数据
     *
     * @param callback 回调
     */
    public void getRoleData(final ResponseItf<ColorTypeEntity> callback) {

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
                        ColorTypeEntity responseObj = gson.fromJson(response, ColorTypeEntity.class);
                        String isResult = responseObj.getResult();
                        if (isResult.equals("success")) {
                            callback.onSuccess(responseObj);
                        } else callback.onError(ResponseCodeConfigs.TYPE_SYS_ERR);
                    }
                });
    }


}
