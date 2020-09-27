package cn.com.cgbchina.rest.visit.model.payment;

import cn.com.cgbchina.rest.visit.model.BaseResult;

/**
 * Comment:
 * Created by 11150321050126 on 2016/12/11.
 */
public class CCPointResult extends BaseResult {
    private String payTime;//yyyyMMddHHmmss

    public String getPayTime() {
        return payTime;
    }

    public void setPayTime(String payTime) {
        this.payTime = payTime;
    }
}
