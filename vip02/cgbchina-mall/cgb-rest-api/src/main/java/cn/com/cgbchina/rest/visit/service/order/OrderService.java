package cn.com.cgbchina.rest.visit.service.order;

import cn.com.cgbchina.rest.visit.model.BaseResult;
import cn.com.cgbchina.rest.visit.model.order.PICCResult;
import cn.com.cgbchina.rest.visit.model.order.ResendOrderInfo;
import cn.com.cgbchina.rest.visit.model.order.SendOrderToO2OInfo;
import cn.com.cgbchina.rest.visit.model.order.ValidPICCInfo;

/**
 * Comment: Created by 11150321050126 on 2016/4/30.
 */
public interface OrderService {
	BaseResult sendO2OOrderInfo(SendOrderToO2OInfo info);

	BaseResult resendOrder(ResendOrderInfo info);

	PICCResult validSecureCode(ValidPICCInfo info);
}
