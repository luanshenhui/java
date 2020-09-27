/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.vendor.controller;

import com.spirit.user.User;
import com.spirit.user.UserUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import com.spirit.web.MessageSources;

import cn.com.cgbchina.trade.model.OrderSubModel;
import cn.com.cgbchina.trade.service.OrderPushService;
import cn.com.cgbchina.trade.service.OrderService;
import lombok.extern.slf4j.Slf4j;

/**
 * 手动推送订单
 * 
 * @author 11150721040343
 * @version 1.0
 * @Since 2016/7/28
 */
@Controller
@Slf4j
@RequestMapping("api/vendor/push")
public class OrderPush {
	@Autowired
	OrderService orderService;
	@Autowired
	MessageSources messageSources;
	@Autowired
	OrderPushService orderPushService;

	/**
	 * 手动推送订单
	 * 
	 * @param id
	 * @return
	 */
	@RequestMapping(method = RequestMethod.POST,produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Boolean watchOrders(String id) {
		Response<Boolean> response = Response.newResponse();
		//获取登录供应商Id
		User user = UserUtil.getUser();
		String vendorName = user.getName();
		String vendorId = user.getVendorId();
		//调用手动推送接口
		response = orderPushService.pushOrder(id,vendorName,vendorId);
		if (response.isSuccess()) {
			return response.getResult();
		}
		log.error("failed to find {},error code:{}", response.getError());
		throw new ResponseException(500, messageSources.get(response.getError()));
	}
}
