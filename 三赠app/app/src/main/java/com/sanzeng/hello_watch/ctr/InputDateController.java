package com.sanzeng.hello_watch.ctr;

import com.google.gson.Gson;
import com.sanzeng.hello_watch.cts.AppApi;
import com.sanzeng.hello_watch.cts.AppConst;
import com.sanzeng.hello_watch.entity.InputDateResponse;
import com.sanzeng.hello_watch.entity.SureRoleResponse;
import com.sanzeng.hello_watch.interfc.ResponseItf;
import com.sanzeng.hello_watch.utils.PfsUtils;
import com.sanzeng.hello_watch.utils.ProjectPfs;
import com.sanzeng.hello_watch.utils.ResponseCodeConfigs;
import com.zhy.http.okhttp.OkHttpUtils;
import com.zhy.http.okhttp.callback.StringCallback;

import java.net.SocketTimeoutException;

import okhttp3.Call;

/**
 * 输入年龄
 * Created by YY on 2017/6/14.
 */
public class InputDateController {

    /**
     * 提交角色数据
     *
     * @param callback 回调
     */
    public void commiteData(String roleType, String strYears, final ResponseItf<InputDateResponse> callback) {
        String inputStr = PfsUtils.readString(ProjectPfs.PFS_SYS, AppConst.M_AUTH_ID);
        String province = PfsUtils.readString(ProjectPfs.PFS_SYS, AppConst.CURRENT_LOCATION);
        int deviceType = PfsUtils.readInteger(ProjectPfs.PFS_SYS, AppConst.DEVICE_TYPE);
        String url = AppApi.JOIN_FAMILY;
        OkHttpUtils.get()
                .url(url)
                .addParams("person_id", inputStr)
                .addParams("name", roleType)
                .addParams("brithday", strYears)
                .addParams("area", province)
                .addParams("type", deviceType + "")
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
                        InputDateResponse responseObj = gson.fromJson(response, InputDateResponse.class);
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

}
