package cn.com.cgbchina.rest.visit.test.sms;

import org.springframework.stereotype.Service;

import cn.com.cgbchina.rest.common.utils.TestClass;
import cn.com.cgbchina.rest.visit.model.BaseResult;
import cn.com.cgbchina.rest.visit.model.sms.BatchSendSMSNotify;
import cn.com.cgbchina.rest.visit.model.sms.SendSMSInfo;
import cn.com.cgbchina.rest.visit.model.sms.SendSMSNotifyResult;
import cn.com.cgbchina.rest.visit.service.sms.SMSService;

/**
 * Comment: Created by 11150321050126 on 2016/4/30.
 */
@Service
public class SMSServiceImpl implements SMSService {
	@Override
	public BaseResult batchSMSNotify(BatchSendSMSNotify notify) {
		return TestClass.debugMethod(BaseResult.class);
	}

	@Override
	public SendSMSNotifyResult sendSMS(SendSMSInfo notify) {
		return TestClass.debugMethod(SendSMSNotifyResult.class);
	}
}
