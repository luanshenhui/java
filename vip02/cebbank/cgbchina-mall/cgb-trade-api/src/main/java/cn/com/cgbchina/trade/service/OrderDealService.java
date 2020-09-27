package cn.com.cgbchina.trade.service;

import cn.com.cgbchina.trade.dto.OrderDealDto;
import cn.com.cgbchina.trade.dto.PayOrderInfoDto;

/**
 * Created by shangqinbin on 2016/6/29.
 */
public interface OrderDealService {

    /**
     * 处理支付网关返回的报文
     *
     * @param payOrderInfoDto
     * @return
     */
    public OrderDealDto dealPay(PayOrderInfoDto payOrderInfoDto);
}
