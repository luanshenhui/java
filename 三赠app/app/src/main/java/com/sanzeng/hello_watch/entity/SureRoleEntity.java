package com.sanzeng.hello_watch.entity;

import com.google.gson.annotations.SerializedName;

import java.io.Serializable;
import java.util.List;

/**
 * 加入家庭组数据体
 * Created by YY on 2017/6/14.
 */
public class SureRoleEntity implements Serializable{

    @SerializedName(value = "role_type")
    private String role_type;

    @SerializedName(value = "role_name")
    private String role_name ;

    public String getRole_type() {
        return role_type;
    }

    public void setRole_type(String role_type) {
        this.role_type = role_type;
    }

    public String getRole_name() {
        return role_name;
    }

    public void setRole_name(String role_name) {
        this.role_name = role_name;
    }
}
