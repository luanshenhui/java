package cn.com.cgbchina.trade.service;

import cn.com.cgbchina.rest.visit.model.sms.SendSMSInfo;
import cn.com.cgbchina.rest.visit.model.sms.SendSMSNotifyResult;
import cn.com.cgbchina.rest.visit.service.sms.SMSService;
import com.spirit.common.model.Response;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by shangqinbin on 2016/7/15.
 */
@Service
@Slf4j
public class SmsMessageServiceImpl implements SmsMessageService {
	@Autowired
	private SMSService smsService;

	@Override
	public Response<Boolean> sendLGSucess(int amountall, int amountsuc, String mobilePhone) {
		Response<Boolean> response = new Response<Boolean>();
		try {
			SendSMSInfo sendSMSInfo = new SendSMSInfo();
			sendSMSInfo.setSmsId("FH");
			sendSMSInfo.setTemplateId("072FH00003");
			sendSMSInfo.setSerial(getSerial());
			sendSMSInfo.setChannelCode("072");
			sendSMSInfo.setSendBranch("010000");
			sendSMSInfo.setMobile(mobilePhone);
			sendSMSInfo.setAmountAll(amountall);
			sendSMSInfo.setAmountsuc(amountsuc);
			SendSMSNotifyResult sendSMSNotifyResult = smsService.sendSMS(sendSMSInfo);
			log.info("短信发送结果:{}", sendSMSNotifyResult.getRetCode());
		} catch (Exception e) {
			log.error("发送失败");
		}
		response.setResult(false);
		return response;
	}

	@Override
	public Response<Boolean> sendLGErr(int product, String mobilePhone) {
		Response<Boolean> response = new Response<Boolean>();
		try {
			SendSMSInfo sendSMSInfo = new SendSMSInfo();
			sendSMSInfo.setSmsId("FH");
			sendSMSInfo.setTemplateId("072FH00004");
			sendSMSInfo.setSerial(getSerial());
			sendSMSInfo.setChannelCode("072");
			sendSMSInfo.setSendBranch("010000");
			sendSMSInfo.setMobile(mobilePhone);
			sendSMSInfo.setProduct(product + "");
			SendSMSNotifyResult sendSMSNotifyResult = smsService.sendSMS(sendSMSInfo);
			log.info("短信发送结果:{}", sendSMSNotifyResult.getRetCode());
		} catch (Exception e) {
			log.error("发送失败");
		}
		response.setResult(false);
		return response;
	}

	@Override
	public Response<Boolean> sendJFSMSMessage(long totalBonus, double totalPrice, String mobilePhone,
			String messageFlag) {
		Response<Boolean> response = new Response<Boolean>();
		try {
			SendSMSInfo sendSMSInfo = new SendSMSInfo();
			sendSMSInfo.setSmsId("FH");
			if (totalPrice > 0 && !"1".equals(messageFlag)) {
				sendSMSInfo.setTemplateId("072FH00001");
				// 尊敬的客户：您广发卡积分换领需求已受理，将在您的帐户内扣除[TOP]积分及换购额[TOS]元，请您留意。
			} else if (messageFlag != null && "1".equals(messageFlag)) {
				sendSMSInfo.setTemplateId("072FH00024");
				sendSMSInfo.setBonusvalue(totalBonus + "");
				// 尊敬的客户：您广发卡积分换领需求已受理，将在您的帐户内扣除[BONUSVALUE]积分，如换领不成功，相应积分将于3天内退还到卡内，请您留意。
			} else {
				sendSMSInfo.setTemplateId("072FH00002");
				// 尊敬的客户：您广发卡积分换领需求已受理，将在您的帐户内扣除[TOP]积分，请您留意。
			}
			sendSMSInfo.setSerial(getSerial());
			sendSMSInfo.setChannelCode("072");
			sendSMSInfo.setSendBranch("010000");
			sendSMSInfo.setMobile(mobilePhone);
			sendSMSInfo.setTop(totalBonus + "");
			if (totalPrice > 0) {
				sendSMSInfo.setTos(totalPrice + "");
			}
			SendSMSNotifyResult sendSMSNotifyResult = smsService.sendSMS(sendSMSInfo);
			log.info("短信发送结果:{}", sendSMSNotifyResult.getRetCode());

		} catch (Exception e) {
			log.error("发送失败");
		}
		response.setResult(false);
		return response;
	}

	@Override
	public Response<Map> sendMsg(Map map) {
		Response<Map> response = new Response<Map>();
		Map returnMap = new HashMap();
		String returnMsg = "";
		String mobilePhone = "";
		String product = "";
		String account = "";
		String reaccount = "";
		String tempLateId = "";
		if (map != null) {
			mobilePhone = (String) map.get("mobilephone");
			product = (String) map.get("product");
			account = (String) map.get("account");
			reaccount = (String) map.get("reaccount");
			tempLateId = (String) map.get("tempLaId");
		}
		log.info("mobilePhone:[" + mobilePhone + "]product:[" + product + "]:account[" + account + "]reaccount:["
				+ reaccount + "]" + "]tempLateId:[" + tempLateId + "]");
		try {
			SendSMSInfo sendSMSInfo = new SendSMSInfo();
			sendSMSInfo.setSmsId("FH");
			if (tempLateId != null && !"".equals(tempLateId)) {
				sendSMSInfo.setTemplateId(tempLateId);
			} else {
				sendSMSInfo.setTemplateId("072FH00013");
				// 您订购的邮购分期产品已成功办理取消（[PRODUCT]，金额为RMB[ACCOUNT]元）。已将扣款金额RMB[REACCOUNT]元退回您的账号，感谢您对广发卡的支持，祝您用卡愉快！
			}
			sendSMSInfo.setSerial(getSerial());
			sendSMSInfo.setChannelCode("072");
			sendSMSInfo.setSendBranch("010000");
			sendSMSInfo.setMobile(mobilePhone);
			sendSMSInfo.setProduct(product);
			sendSMSInfo.setAmount(account);
			sendSMSInfo.setReaccount(reaccount);
			SendSMSNotifyResult sendSMSNotifyResult = smsService.sendSMS(sendSMSInfo);
			returnMsg = "短信发送手机号:" + mobilePhone + ",结果：" + sendSMSNotifyResult.getRetCode();
			returnMap.put("msg", returnMsg);
		} catch (Exception e) {
			log.error("发送失败");
		}
		response.setResult(returnMap);
		return response;
	}

	/**
	 * 优惠券不匹配短信
	 * 
	 * @param mobilePhone
	 * @return
	 */
	public boolean sendConponMsg(String mobilePhone) {
		try {
			SendSMSInfo sendSMSInfo = new SendSMSInfo();
			// 手机验证码
			sendSMSInfo.setSmsId("FH");// 商城要改FH
			sendSMSInfo.setTemplateId("072FH00026");// 短信模板
			// 感谢您订购广发商城分期产品！您提供的优惠券金额匹配不成功，本次订购未成功，请登陆广发商城查询“我的优惠券”后重新订购，祝您购物愉快！
			sendSMSInfo.setFixtemplateId("");
			sendSMSInfo.setSerial(getSerial());
			sendSMSInfo.setChannelCode("072");// 商城要改072
			sendSMSInfo.setSendBranch("010000");// 机构号
			sendSMSInfo.setMobile(mobilePhone);
			sendSMSInfo.setIdType("");
			sendSMSInfo.setIdCode("");
			SendSMSNotifyResult sendSMSNotifyResult = smsService.sendSMS(sendSMSInfo);
		} catch (Exception e) {
			log.error("发送失败:{}", e.getMessage());
		}
		return true;
	}

	/**
	 * 资格客户但时间过期短信
	 * 
	 * @param mobilePhone
	 * @return
	 */
	public Response<Boolean> sendOverDueMsg(String mobilePhone) {
		Response<Boolean> response = new Response<Boolean>();
		try {
			SendSMSInfo sendSMSInfo = new SendSMSInfo();
			// 手机验证码
			sendSMSInfo.setSmsId("FH");// 商城要改FH
			sendSMSInfo.setTemplateId("072FH00032");// 短信模板
			// 您本次订购失败，如有疑问请致电4008895508-2-1咨询。
			sendSMSInfo.setFixtemplateId("");
			sendSMSInfo.setSerial(getSerial());
			sendSMSInfo.setChannelCode("072");// 商城要改072
			sendSMSInfo.setSendBranch("010000");// 机构号
			sendSMSInfo.setMobile(mobilePhone);
			sendSMSInfo.setIdType("");
			sendSMSInfo.setIdCode("");
			SendSMSNotifyResult sendSMSNotifyResult = smsService.sendSMS(sendSMSInfo);
			log.info("短信发送结果:{}", sendSMSNotifyResult.getRetCode());
		} catch (Exception e) {
			log.info("发送失败:", e);
		}
		response.setResult(false);
		return response;
	}

	/**
	 * 返回流水号 格式YYYYMMDDHHMMSSXXXXXX
	 *
	 * @return
	 * @author: 贺雅飞
	 */
	private String getSerial() {
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMddHHmmss");
		java.util.Date dateTime = new java.util.Date();
		String p_Serial = dateFormat.format(dateTime);
		String A_Serial = "00";
		return p_Serial + A_Serial;
	}

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		SmsMessageServiceImpl smsMessageServiceImpl = new SmsMessageServiceImpl();
		smsMessageServiceImpl.sendLGSucess(300, 200, "13660206739");
		// smsMessageServiceImpl.sendJFSMSMessage(300, 0.00, "13660206739" , "1");
	}
}
