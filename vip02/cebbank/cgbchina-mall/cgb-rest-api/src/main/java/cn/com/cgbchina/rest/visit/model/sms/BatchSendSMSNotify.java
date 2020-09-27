package cn.com.cgbchina.rest.visit.model.sms;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.validation.constraints.NotNull;

import cn.com.cgbchina.rest.common.annotation.Special;
import cn.com.cgbchina.rest.visit.model.BaseQuery;

/**
 * Comment: Created by 11150321050126 on 2016/4/30.
 */
public class BatchSendSMSNotify extends BaseQuery implements Serializable {
	private static final long serialVersionUID = 6847962754045884667L;
	@NotNull
	private String transCode;
	@NotNull
	private String sendId;
	@NotNull
	@Special("yyyyMMdd")
	private Date sendDate;
	@NotNull
	private String sendSn;
	@NotNull
	private String channelId;
	@NotNull
	private String fileName;
	@NotNull
	private String branch;
	@NotNull
	private String subBranch;
	@NotNull
	private String operatorId;
	private String channelCode;

	public String getChannelcode() {
		return channelCode;
	}

	public void setChannelcode(String channelcode) {
		this.channelCode = channelcode;
	}

	private List<BatchSendSMSNotifyInfo> infos = new ArrayList<BatchSendSMSNotifyInfo>();

	public List<BatchSendSMSNotifyInfo> getInfos() {
		return infos;
	}

	public void setInfos(List<BatchSendSMSNotifyInfo> infos) {
		this.infos = infos;
	}

	public String getTransCode() {
		return transCode;
	}

	public void setTransCode(String transCode) {
		this.transCode = transCode;
	}

	public String getSendId() {
		return sendId;
	}

	public void setSendId(String sendId) {
		this.sendId = sendId;
	}

	public Date getSendDate() {
		return sendDate;
	}

	public void setSendDate(Date sendDate) {
		this.sendDate = sendDate;
	}

	public String getSendSn() {
		return sendSn;
	}

	public void setSendSn(String sendSn) {
		this.sendSn = sendSn;
	}

	public String getChannelId() {
		return channelId;
	}

	public void setChannelId(String channelId) {
		this.channelId = channelId;
	}

	public String getFileName() {
		return fileName;
	}

	public void setFileName(String fileName) {
		this.fileName = fileName;
	}

	public String getBranch() {
		return branch;
	}

	public void setBranch(String branch) {
		this.branch = branch;
	}

	public String getSubBranch() {
		return subBranch;
	}

	public void setSubBranch(String subBranch) {
		this.subBranch = subBranch;
	}

	public String getOperatorId() {
		return operatorId;
	}

	public void setOperatorId(String operatorId) {
		this.operatorId = operatorId;
	}
}
