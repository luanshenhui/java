package cn.com.cgbchina.rest.visit.vo.sms;

import cn.com.cgbchina.rest.visit.model.BaseQuery;

import java.io.Serializable;
import java.util.Date;

/**
 * Comment: Created by 11150321050126 on 2016/4/30.
 */
public class BatchSendSMSNotifyInfoVO implements Serializable {
	private String smsId;
	private String templateId;
	private String fixTemplateId;
	private String channelCode;
	private String sendBranch;
	private String mobile;
	private String idType;
	private String idCode;
	private String signupacct;

	public String getSmsId() {
		return smsId;
	}

	public void setSmsId(String smsId) {
		this.smsId = smsId;
	}

	public String getTemplateId() {
		return templateId;
	}

	public void setTemplateId(String templateId) {
		this.templateId = templateId;
	}

	public String getFixTemplateId() {
		return fixTemplateId;
	}

	public void setFixTemplateId(String fixTemplateId) {
		this.fixTemplateId = fixTemplateId;
	}

	public String getChannelCode() {
		return channelCode;
	}

	public void setChannelCode(String channelCode) {
		this.channelCode = channelCode;
	}

	public String getSendBranch() {
		return sendBranch;
	}

	public void setSendBranch(String sendBranch) {
		this.sendBranch = sendBranch;
	}

	public String getMobile() {
		return mobile;
	}

	public void setMobile(String mobile) {
		this.mobile = mobile;
	}

	public String getIdType() {
		return idType;
	}

	public void setIdType(String idType) {
		this.idType = idType;
	}

	public String getIdCode() {
		return idCode;
	}

	public void setIdCode(String idCode) {
		this.idCode = idCode;
	}

	public String getSignupacct() {
		return signupacct;
	}

	public void setSignupacct(String signupacct) {
		this.signupacct = signupacct;
	}

}
