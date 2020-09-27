package com.sanzeng.hello_watch.utils;

import com.google.gson.annotations.SerializedName;

import java.io.Serializable;

/**
 * 在Response中存在一个JSONObject,名字为TreatmentResult,
 * 这个对象将包含请求的响应码code和验证消息message。
 * <p>
 * Created by YY on 16/9/28.
 */

public class TreatmentResult implements Serializable {

    @SerializedName(value = "code")
    private int code;

    @SerializedName(value = "message")
    private String message;

    public int getCode() {
        return code;
    }

    public void setCode(int code) {
        this.code = code;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    @Override
    public String toString() {
        return "TreatmentResult{" +
                "code=" + code +
                ", message='" + message + '\'' +
                '}';
    }
}
