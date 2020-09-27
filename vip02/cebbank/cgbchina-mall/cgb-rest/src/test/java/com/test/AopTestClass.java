package com.test;

import javax.annotation.Resource;

import org.junit.Assert;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.spirit.util.JsonMapper;

import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.model.activity.ActivityQuery;
import cn.com.cgbchina.rest.provider.model.activity.ActivityQueryReturn;
import cn.com.cgbchina.rest.provider.service.activity.ActivityQueryService;
import cn.com.cgbchina.rest.visit.model.sms.BatchSendSMSNotify;
import cn.com.cgbchina.rest.visit.service.coupon.CouponService;
import cn.com.cgbchina.rest.visit.service.sms.SMSService;
import lombok.extern.slf4j.Slf4j;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = "classpath*:spring/rest-service-context.xml")
@ActiveProfiles("dev")
@Slf4j
public class AopTestClass {
	@Resource
	CouponService couponService;
	JsonMapper jsonMapper = JsonMapper.nonEmptyMapper();
	@Resource
	ActivityQueryService activityQueryService;

	public void test1() {
		ActivityQuery info = BeanUtils.randomClass(ActivityQuery.class);
		ActivityQueryReturn result = activityQueryService.query(info);
		System.out.println("输出结果:" + jsonMapper.toJson(result));
		Assert.assertNotNull(activityQueryService.getClass().getName() + " 测试失败", result);
	}

	@Resource
	SMSService smsService;

	@Test
	public void test4() {
		BatchSendSMSNotify a = BeanUtils.randomClass(BatchSendSMSNotify.class);
		smsService.batchSMSNotify(a);
		// jsonMapper.toJson( );
	}

}
