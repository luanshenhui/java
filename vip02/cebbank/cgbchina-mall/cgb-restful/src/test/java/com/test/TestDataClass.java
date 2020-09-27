package com.test;

import java.util.HashMap;

import javax.annotation.Resource;

import lombok.extern.slf4j.Slf4j;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.spirit.util.JsonMapper;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = "classpath*:spring/rest-service-context.xml")
@ActiveProfiles("dev")
@Slf4j
public class TestDataClass {
	@Resource(name = "testdata")
	private HashMap<String, String> testData;

	public HashMap<String, String> getTestData() {
		return testData;
	}

	public void setTestData(HashMap<String, String> testData) {
		this.testData = testData;
	}

	private JsonMapper jsomMapper = JsonMapper.nonEmptyMapper();

	@Test
	public void ss() {
		System.out.println(jsomMapper.toJson(testData));
	}
}
