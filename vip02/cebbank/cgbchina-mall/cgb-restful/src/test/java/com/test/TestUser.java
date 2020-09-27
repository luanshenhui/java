package com.test;

import javax.annotation.Resource;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.spirit.util.JsonMapper;

import cn.com.cgbchina.rest.visit.model.user.LoginInfo;
import cn.com.cgbchina.rest.visit.service.user.UserService;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = "classpath*:spring/restful-service-content.xml")
@ActiveProfiles("dev")
public class TestUser {
	@Resource
	private UserService userServiceImpl;
	private JsonMapper jsonMapper = JsonMapper.nonEmptyMapper();

	@Test
	public void test() {
		Object obj = userServiceImpl.login(new LoginInfo());
		String str = jsonMapper.toJson(obj);
		System.err.println(str);
	}
}
