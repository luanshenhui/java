package cn.com.cgbchina.rest.visit.service.sms;

import cn.com.cgbchina.rest.visit.model.BaseResult;
import cn.com.cgbchina.rest.visit.model.sms.BatchSendSMSNotify;
import cn.com.cgbchina.rest.visit.model.sms.SendSMSInfo;
import cn.com.cgbchina.rest.visit.model.sms.SendSMSNotifyResult;

/**
 * Comment: Created by 11150321050126 on 2016/4/30.
 */
public interface SMSService {
	BaseResult batchSMSNotify(BatchSendSMSNotify notify);

	SendSMSNotifyResult sendSMS(SendSMSInfo notify);
}
