package cn.com.cgbchina.rest.visit.model.sms;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.validation.constraints.NotNull;

import cn.com.cgbchina.rest.common.annotation.Special;
import cn.com.cgbchina.rest.visit.model.BaseQuery;
import com.google.common.base.Objects;

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
	private String channelCode; // 渠道代码
	@NotNull
	private String fileName;
	@NotNull
	private String branch;
	@NotNull
	private String subBranch;
	@NotNull
	private String operatorId;

	private List<BatchSendSMSNotifyInfo> infos = new ArrayList<BatchSendSMSNotifyInfo>();

	public String getChannelCode() {
		return channelCode;
	}

	public void setChannelCode(String channelCode) {
		this.channelCode = channelCode;
	}

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


	@Override
	public String toString() {
		return Objects.toStringHelper(this)
				.add("transCode", transCode)
				.add("sendId", sendId)
				.add("sendDate", sendDate)
				.add("sendSn", sendSn)
				.add("channelId", channelId)
				.add("channelCode", channelCode)
				.add("fileName", fileName)
				.add("branch", branch)
				.add("subBranch", subBranch)
				.add("operatorId", operatorId)
				.toString();
	}
}
