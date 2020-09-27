package com.test;

import java.lang.reflect.Method;

import javax.annotation.Resource;

import lombok.extern.slf4j.Slf4j;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import cn.com.cgbchina.restful.controller.CallServiceController;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("classpath*:spring/rest-service-context.xml")
@ActiveProfiles("dev")
@Slf4j
public class TestReflect {

	@Resource
	private CallServiceController callServiceController;

	public void testBaseReflect() throws Exception {
		Method[] methods = callServiceController.getClass().getDeclaredMethods();
		System.out.println(methods.length);
		for (Method method : methods) {
			if (method.getParameterTypes().length > 0) {
				String paramClazz = method.getParameterTypes()[0].getName();

				String returnClazz = method.getReturnType().getName();
				System.out.println(method.getName() + paramClazz + " " + returnClazz);
				if (method.getName().equals("testReflect")) {
					String a = (String) method.invoke(callServiceController, "cc");
					System.out.println(a);
				}
			}
		}
	}

	@Test
	public void testService() throws Exception {
		callServiceController.callMethods("couponServiceImpl", "queryCouponInfo", null);
	}
}
