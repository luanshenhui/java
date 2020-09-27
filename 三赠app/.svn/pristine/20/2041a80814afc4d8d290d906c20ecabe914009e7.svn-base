package com.sanzeng.hello_watch.ctr;

import com.google.gson.Gson;
import com.sanzeng.hello_watch.cts.AppApi;
import com.sanzeng.hello_watch.entity.JoinFamilyResponse;
import com.sanzeng.hello_watch.entity.MainResponse;
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
 * 输入手环码控制器
 * Created by YY on 2017/6/14.
 */
public class JoinFamilyController {


    public void commiteData(String clentId, final ResponseItf<JoinFamilyResponse> callback) {

        String url = AppApi.INPUT_WATCH_CODE;
        OkHttpUtils.get()
                .url(url)
                .addParams("clentId", clentId)
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
                        JoinFamilyResponse responseObj = gson.fromJson(response, JoinFamilyResponse.class);
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
