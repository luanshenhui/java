package cn.com.cgbchina.rest.visit.test.order;

import org.springframework.stereotype.Service;

import cn.com.cgbchina.rest.common.utils.TestClass;
import cn.com.cgbchina.rest.visit.model.BaseResult;
import cn.com.cgbchina.rest.visit.model.order.PICCResult;
import cn.com.cgbchina.rest.visit.model.order.ResendOrderInfo;
import cn.com.cgbchina.rest.visit.model.order.SendOrderToO2OInfo;
import cn.com.cgbchina.rest.visit.model.order.ValidPICCInfo;
import cn.com.cgbchina.rest.visit.service.order.OrderService;

/**
 * Comment: Created by 11150321050126 on 2016/4/30.
 */
@Service
public class OrdersServiceImpl implements OrderService {
	@Override
	public BaseResult sendO2OOrderInfo(SendOrderToO2OInfo info) {
		return TestClass.debugMethod(BaseResult.class);
	}

	@Override
	public BaseResult resendOrder(ResendOrderInfo info) {
		return TestClass.debugMethod(BaseResult.class);
	}

	@Override
	public PICCResult validSecureCode(ValidPICCInfo info) {
		return TestClass.debugMethod(PICCResult.class);
	}
}
