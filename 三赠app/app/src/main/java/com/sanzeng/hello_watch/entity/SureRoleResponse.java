package com.sanzeng.hello_watch.entity;

import com.google.gson.annotations.SerializedName;
import com.sanzeng.hello_watch.utils.Response;

import java.io.Serializable;
import java.util.List;

/**
 * 加入家庭组数据体
 * Created by YY on 2017/6/14.
 */
public class SureRoleResponse implements Serializable{

    @SerializedName(value = "result")
    private String result;

    @SerializedName(value = "msg")
    private String msg;

    @SerializedName(value = "data")
    private List<SureRoleEntity> data;

    public String isResult() {
        return result;
    }

    public void setResult(String result) {
        this.result = result;
    }

    public List<SureRoleEntity> getData() {
        return data;
    }

    public void setData(List<SureRoleEntity> data) {
        this.data = data;
    }

    public String getResult() {
        return result;
    }

    public String getMsg() {
        return msg;
    }

    public void setMsg(String msg) {
        this.msg = msg;
    }
}
