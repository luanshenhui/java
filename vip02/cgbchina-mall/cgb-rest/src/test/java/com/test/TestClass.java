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
import cn.com.cgbchina.rest.visit.model.sms.BatchSendSMSNotify;
import cn.com.cgbchina.rest.visit.model.user.EEA1Info;
import cn.com.cgbchina.rest.visit.model.user.EEA1InfoResult;
import cn.com.cgbchina.rest.visit.service.coupon.CouponService;
import cn.com.cgbchina.rest.visit.service.order.OrderService;
import cn.com.cgbchina.rest.visit.service.sms.SMSService;
import cn.com.cgbchina.rest.visit.service.user.UserServiceImpl;
import lombok.extern.slf4j.Slf4j;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = "classpath*:spring/rest-service-context.xml")
@ActiveProfiles("dev")
@Slf4j
public class TestClass {
	@Resource
	CouponService couponService;
	JsonMapper jsonMapper = JsonMapper.nonEmptyMapper();
	@Resource
	OrderService orderService;
	@Resource
	SMSService smsService;

	@Test
	public void test4() {
		BatchSendSMSNotify a = BeanUtils.randomClass(BatchSendSMSNotify.class);
		smsService.batchSMSNotify(a);
		// jsonMapper.toJson( );
	}
}
