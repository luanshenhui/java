package cn.com.cgbchina.batch.service;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import lombok.extern.slf4j.Slf4j;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import cn.com.cgbchina.batch.dao.BatchEspActRemindDao;
import cn.com.cgbchina.batch.manager.BatchEspActRemindManager;
import cn.com.cgbchina.batch.model.BatchEspActRemindModel;
import cn.com.cgbchina.common.utils.DateHelper;
import cn.com.cgbchina.rest.visit.model.sms.SendSMSInfo;
import cn.com.cgbchina.rest.visit.service.sms.SMSService;

import com.spirit.common.model.Response;

@Service
@Slf4j
public class BatchEspActRemindServiceImpl implements BatchEspActRemindService{
	@Autowired
	private BatchEspActRemindDao dao;
	private int LIMIT=5000;
	@Autowired
	private SMSService smsService;
	@Autowired
	private BatchEspActRemindManager manager;
	@Value("#{app.remindTime}")
	private int remindTime;
	@Override
	public Response<Boolean> sendRemindMsg() {
		Response<Boolean> result=new Response<>();
		try {
			//用来去掉重复的通知，防止每次多发好多次短信
			Map<String,Object> maps=new HashMap<>();
			Date endDate = DateHelper.addMin(new Date(), remindTime);
			long size=dao.findNeedSendMsgCount(endDate);
			for(long offset=0;offset<size;offset+=LIMIT){
				List<BatchEspActRemindModel> modelList = dao.findNeedSendMsg(endDate,offset,LIMIT);
				List<String> ids=new ArrayList<>();
				for(int i=0 ; modelList!=null && i<modelList.size() ; i++){
					BatchEspActRemindModel model=modelList.get(i);
					if(!maps.containsKey(model.getCustId())){
						SendSMSInfo sendSMSInfo=new SendSMSInfo();
						sendSMSInfo.setSmsId("FH");
						sendSMSInfo.setTemplateId("072FH00027");
						sendSMSInfo.setSerial(getSerial());
						sendSMSInfo.setChannelCode("072");
						sendSMSInfo.setSendBranch("010000");
						sendSMSInfo.setMobile(model.getCustMobile());
						sendSMSInfo.setIdType("");
						sendSMSInfo.setIdCode("");
						smsService.sendSMS(sendSMSInfo);
						maps.put(model.getCustId(), null);
					}
					ids.add(String.valueOf(model.getId()));
					manager.updateSendFlg(ids, "1");
				}
			}
		} catch (Exception e) {
			log.error("[发送App提醒短信异常]",e);
			result.setResult(false);
		}
		result.setResult(true);
		return result;
	}
	private String getSerial() {
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMddHHmmss");
		java.util.Date dateTime = new java.util.Date();
		String p_Serial = dateFormat.format(dateTime);
		String A_Serial = "00";
		return p_Serial + A_Serial;
	}
}
