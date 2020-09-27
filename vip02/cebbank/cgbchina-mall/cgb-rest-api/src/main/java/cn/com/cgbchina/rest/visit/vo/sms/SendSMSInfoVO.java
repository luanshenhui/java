package cn.com.cgbchina.rest.visit.vo.sms;

import cn.com.cgbchina.rest.visit.vo.BaseQueryVo;

import java.io.Serializable;

/**
 * Comment: Created by 11150321050126 on 2016/4/30.
 */
public class SendSMSInfoVO extends BaseQueryVo implements Serializable {
	private String smsId;
	private String templateId;
	private String fixtemplateId;
	private String serial;
	private String channelCode;
	private String sendBranch;
	private String mobile;
	private String idType;
	private String idCode;
	private String signupacct;
	private String top;
	private String tos;
	private Integer amountAll;
	private Integer amountsuc;
	private String product;

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

	public String getFixtemplateId() {
		return fixtemplateId;
	}

	public void setFixtemplateId(String fixtemplateId) {
		this.fixtemplateId = fixtemplateId;
	}

	public String getSerial() {
		return serial;
	}

	public void setSerial(String serial) {
		this.serial = serial;
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

	public String getTop() {
		return top;
	}

	public void setTop(String top) {
		this.top = top;
	}

	public String getTos() {
		return tos;
	}

	public void setTos(String tos) {
		this.tos = tos;
	}

	public Integer getAmountAll() {
		return amountAll;
	}

	public void setAmountAll(Integer amountAll) {
		this.amountAll = amountAll;
	}

	public Integer getAmountsuc() {
		return amountsuc;
	}

	public void setAmountsuc(Integer amountsuc) {
		this.amountsuc = amountsuc;
	}

	public String getProduct() {
		return product;
	}

	public void setProduct(String product) {
		this.product = product;
	}
}
