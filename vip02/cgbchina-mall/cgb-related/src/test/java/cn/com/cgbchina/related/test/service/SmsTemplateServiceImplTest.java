/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.related.test.service;

import javax.annotation.Resource;

import org.junit.Assert;
import org.junit.Test;

import com.spirit.common.model.Response;
import com.spirit.util.JsonMapper;

import cn.com.cgbchina.related.test.BaseTestCase;
import cn.com.cgbchina.rest.visit.model.BaseResult;

/**
 * @author A111503210500871
 * @version 1.0
 * @Since 2016/8/3
 */
public class SmsTemplateServiceImplTest extends BaseTestCase {

	private JsonMapper jsonMapper = JsonMapper.nonEmptyMapper();

//	@Resource
//	private SmsTemplateServiceImpl smsTemplateServiceImpl;

//	@Test
//	public void sendMessageTest() {
//		// 主键
//		Long id = null;
//		// 短信模板id
//		String smspId = null;
//		Response<BaseResult> result = smsTemplateServiceImpl.sendMessage(id, smspId);
//		System.out.println("输出结果：" + jsonMapper.toJson(result));
//		Assert.assertNotNull(smsTemplateServiceImpl.getClass().getName() + "对比失败", result);
//
//	}
}
