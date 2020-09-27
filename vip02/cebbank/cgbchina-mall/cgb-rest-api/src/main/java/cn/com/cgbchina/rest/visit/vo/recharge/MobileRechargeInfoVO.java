package cn.com.cgbchina.rest.visit.vo.recharge;

import cn.com.cgbchina.rest.visit.vo.BaseQueryVo;

import java.io.Serializable;
import java.math.BigDecimal;

/**
 * Comment: Created by 11150321050126 on 2016/4/30.
 */
public class MobileRechargeInfoVO extends BaseQueryVo implements Serializable {
	private String templateCodeName;
	private String TransCode;
	private String sysId;
	private String channelCode;
	private String channelDate;
	private String channelTime;
	private String mobile;
	private BigDecimal amount;
	private String comment;

	public String getTemplateCodeName() {
		return templateCodeName;
	}

	public void setTemplateCodeName(String templateCodeName) {
		this.templateCodeName = templateCodeName;
	}

	public String getTransCode() {
		return TransCode;
	}

	public void setTransCode(String transCode) {
		TransCode = transCode;
	}

	public String getSysId() {
		return sysId;
	}

	public void setSysId(String sysId) {
		this.sysId = sysId;
	}

	public String getChannelCode() {
		return channelCode;
	}

	public void setChannelCode(String channelCode) {
		this.channelCode = channelCode;
	}

	public String getChannelDate() {
		return channelDate;
	}

	public void setChannelDate(String channelDate) {
		this.channelDate = channelDate;
	}

	public String getChannelTime() {
		return channelTime;
	}

	public void setChannelTime(String channelTime) {
		this.channelTime = channelTime;
	}

	public String getMobile() {
		return mobile;
	}

	public void setMobile(String mobile) {
		this.mobile = mobile;
	}

	public BigDecimal getAmount() {
		return amount;
	}

	public void setAmount(BigDecimal amount) {
		this.amount = amount;
	}

	public String getComment() {
		return comment;
	}

	public void setComment(String comment) {
		this.comment = comment;
	}

}
