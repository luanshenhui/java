package cn.com.cgbchina.related.model;

import java.io.Serializable;

import lombok.Getter;
import lombok.Setter;

public class InfoOutSystemModel implements Serializable {

    @Getter
    @Setter
    private Long id;//自增主键
    @Getter
    @Setter
    private String orderId;//子订单号
    @Getter
    @Setter
    private String verifyCode;//验证码
    @Getter
    @Setter
    private String validateStatus;//验证码状态
    @Getter
    @Setter
    private String systemRole;//外系统标志
    @Getter
    @Setter
    private String verifyId;//验证码id
    @Getter
    @Setter
    private String msgtype;//回执信息类型
    @Getter
    @Setter
    private String mobile;//接收的手机号码
    @Getter
    @Setter
    private String status;//发送状态
    @Getter
    @Setter
    private String createOper;//创建人
    @Getter
    @Setter
    private java.util.Date createTime;//创建时间
    @Getter
    @Setter
    private String modifyOper;//修改人
    @Getter
    @Setter
    private java.util.Date modifyTime;//修改时间
}