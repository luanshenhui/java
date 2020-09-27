package com.sanzeng.hello_watch.entity;

import com.google.gson.annotations.SerializedName;
import com.sanzeng.hello_watch.utils.Response;

import java.io.Serializable;

/**
 * 加入家庭组数据体
 * Created by YY on 2017/6/14.
 */
public class JoinFamilyResponse implements Serializable {

    @SerializedName(value = "result")
    private String result;

    @SerializedName(value = "msg")
    private String msg;

    public String getResult() {
        return result;
    }

    public void setResult(String result) {
        this.result = result;
    }

    public String getMsg() {
        return msg;
    }

    public void setMsg(String msg) {
        this.msg = msg;
    }
}
