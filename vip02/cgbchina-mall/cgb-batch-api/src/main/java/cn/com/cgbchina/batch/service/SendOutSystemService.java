package cn.com.cgbchina.batch.service;

import com.spirit.common.model.Response;

/**
 * 批量查询出需要推送的订单，推送至外网O2O系统
 *
 * Created by 周志彤 on 2016/7/7.
 */
public interface SendOutSystemService {

    /**
     * 定时推送订单至外网O2O JOB
     */
    Response<Boolean> sendOrders2Outsystem();
}
