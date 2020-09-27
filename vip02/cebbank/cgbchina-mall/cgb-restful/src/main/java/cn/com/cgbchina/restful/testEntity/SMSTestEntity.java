package cn.com.cgbchina.restful.testEntity;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import cn.com.cgbchina.rest.visit.model.sms.BatchSendSMSNotify;
import cn.com.cgbchina.rest.visit.model.sms.BatchSendSMSNotifyInfo;
import cn.com.cgbchina.rest.visit.model.sms.SendSMSInfo;

import com.spirit.util.JsonMapper;

public class SMSTestEntity {
	JsonMapper jsonMapper = JsonMapper.nonEmptyMapper();

	public String getBatchSendSMSNotifyJson() {
		BatchSendSMSNotify info = new BatchSendSMSNotify();
		info.setTransCode("SMS093");
		info.setSendId("999");
		info.setSendDate(new Date());
		info.setSendSn("123");
		info.setChannelId("SHOP");
		info.setFileName("123");
		info.setBranch("123");
		info.setSubBranch("aaa");
		info.setOperatorId("123");
		List<BatchSendSMSNotifyInfo> infos = new ArrayList<BatchSendSMSNotifyInfo>();
		BatchSendSMSNotifyInfo sendInfo = new BatchSendSMSNotifyInfo();
		sendInfo.setSmsId("123");
		sendInfo.setTemplateId("123");
		sendInfo.setChannelCode("SHOP");
		sendInfo.setSendBranch("123");
		sendInfo.setMobile("18675186626");
		infos.add(sendInfo);
		info.setInfos(infos);
		String json = jsonMapper.toJson(info);
		return json;
	}

	public String getSendSMSInfoJson() {
		SendSMSInfo info = new SendSMSInfo();
		info.setSmsId("FH");
		info.setTemplateId("072FH00001");
		info.setFixtemplateId("");
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");

		info.setSerial(sdf.format(new Date()) + "12345");
		info.setChannelCode("072");
		info.setSendBranch("010000");
		info.setMobile("18675186626");

		String json = jsonMapper.toJson(info);
		return json;
	}
}
