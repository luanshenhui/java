package cn.com.cgbchina.rest.visit.model.recharge;

import java.io.Serializable;
import java.math.BigDecimal;

import javax.validation.constraints.NotNull;

import cn.com.cgbchina.rest.visit.model.BaseQuery;

/**
 * Comment: Created by 11150321050126 on 2016/4/30.
 */
public class MobileRechargeInfo extends BaseQuery implements Serializable {
	private static final long serialVersionUID = -8038397642442433978L;
	@NotNull
	private String templateCodeName;
	@NotNull
	private String TransCode;
	@NotNull
	private String sysId;
	@NotNull
	private String channelCode;
	@NotNull
	private String channelDate;
	@NotNull
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
