package com.test.outinterface;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.annotation.Resource;

import org.junit.Assert;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.spirit.util.JsonMapper;

import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.visit.model.BaseResult;
import cn.com.cgbchina.rest.visit.model.sms.BatchSendSMSNotify;
import cn.com.cgbchina.rest.visit.model.sms.BatchSendSMSNotifyInfo;
import cn.com.cgbchina.rest.visit.service.sms.SMSService;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = "classpath*:spring/rest-service-context.xml")
@ActiveProfiles("dev")
public class sMSServiceTest {

	private JsonMapper jsonMapper = JsonMapper.nonEmptyMapper();

	@Resource
	SMSService sMSService;

	@Test
	public void test_batchSMSNotify_01() {
		BatchSendSMSNotify batchSendSMSNotify = BeanUtils.randomClass(BatchSendSMSNotify.class);

		// 固定参数
		batchSendSMSNotify.setTransCode("SMS093");
		batchSendSMSNotify.setSendId("SHOP");
		batchSendSMSNotify.setSendDate(new Date());
		batchSendSMSNotify.setSendSn("123");
		batchSendSMSNotify.setChannelId("72");
		batchSendSMSNotify.setBranch("999999");
		batchSendSMSNotify.setSubBranch("999999");
		batchSendSMSNotify.setOperatorId("72");

		List<BatchSendSMSNotifyInfo> infos = new ArrayList<BatchSendSMSNotifyInfo>();
		// 第一组数据
		BatchSendSMSNotifyInfo batchSendSMSNotifyInfo1 = new BatchSendSMSNotifyInfo();
		batchSendSMSNotifyInfo1.setSmsId("FH");
		batchSendSMSNotifyInfo1.setTemplateId("072FH00028");// 商城提供--短信模板id
		batchSendSMSNotifyInfo1.setChannelCode("SHOP");
		batchSendSMSNotifyInfo1.setSendBranch("999999");
		batchSendSMSNotifyInfo1.setMobile("13403595758");// 商城提供--手机号码
		// 第二组数据
		BatchSendSMSNotifyInfo batchSendSMSNotifyInfo2 = new BatchSendSMSNotifyInfo();
		batchSendSMSNotifyInfo2.setSmsId("FH");
		batchSendSMSNotifyInfo2.setTemplateId("072FH00028");// 商城提供--短信模板id
		batchSendSMSNotifyInfo2.setChannelCode("SHOP");
		batchSendSMSNotifyInfo2.setSendBranch("999999");
		batchSendSMSNotifyInfo2.setMobile("13403596689");// 商城提供--手机号码
		// 第三组数据
		BatchSendSMSNotifyInfo batchSendSMSNotifyInfo3 = new BatchSendSMSNotifyInfo();
		batchSendSMSNotifyInfo3.setSmsId("FH");
		batchSendSMSNotifyInfo3.setTemplateId("072FH00028");// 商城提供--短信模板id
		batchSendSMSNotifyInfo3.setChannelCode("SHOP");
		batchSendSMSNotifyInfo3.setSendBranch("999999");
		batchSendSMSNotifyInfo3.setMobile("13403598875");// 商城提供--手机号码
		// 将数据放入list
		infos.add(batchSendSMSNotifyInfo1);
		infos.add(batchSendSMSNotifyInfo2);
		infos.add(batchSendSMSNotifyInfo3);
		// 将list放入batchSendSMSNotify
		batchSendSMSNotify.setInfos(infos);

		// 结果预期： 00---处理成功
		// 01---处理失败 +详细错误中文描述
		BaseResult result = sMSService.batchSMSNotify(batchSendSMSNotify);
		System.out.println("输出结果：" + jsonMapper.toJson(result));
		Assert.assertNotNull(sMSService.getClass().getName() + "对比失败", result);
	}

}
