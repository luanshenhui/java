package com.test;

import javax.annotation.Resource;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.spirit.util.JsonMapper;

import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.visit.model.BaseResult;
import cn.com.cgbchina.rest.visit.model.coupon.ActivateCouponInfo;
import cn.com.cgbchina.rest.visit.model.coupon.ActivateCouponProjectResutl;
import cn.com.cgbchina.rest.visit.model.order.ResendOrderInfo;
import cn.com.cgbchina.rest.visit.model.user.EEA1Info;
import cn.com.cgbchina.rest.visit.model.user.EEA1InfoResult;
import cn.com.cgbchina.rest.visit.service.coupon.CouponService;
import cn.com.cgbchina.rest.visit.service.order.OrderService;
import cn.com.cgbchina.rest.visit.service.user.UserServiceImpl;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = "classpath*:spring/rest-service-context.xml")
@ActiveProfiles("dev")
public class TestClass2 {
	@Resource
	CouponService couponService;
	JsonMapper jsonMapper = JsonMapper.nonEmptyMapper();
	@Resource
	OrderService orderService;
	@Resource
	UserServiceImpl userServiceImpl;

	@Test
	public void test1() {
		ActivateCouponInfo info = new ActivateCouponInfo();
		info.setContIdCard("ab");
		ActivateCouponProjectResutl result = couponService.activateCoupon(info);
		System.out.println("输出:" + jsonMapper.toJson(result));
	}

	public void test2() {
		ResendOrderInfo info = new ResendOrderInfo();
		BaseResult result = orderService.resendOrder(info);
		System.out.println("输出:" + jsonMapper.toJson(result));
	}

}
