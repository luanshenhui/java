package cn.com.cgbchina.rest.visit.vo.sms;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import cn.com.cgbchina.rest.common.annotation.XMLNodeName;
import cn.com.cgbchina.rest.visit.vo.BaseQueryVo;

/**
 * Comment: Created by 11150321050126 on 2016/4/30.
 */
public class BatchSendSMSNotifyVO extends BaseQueryVo implements Serializable {
	@XMLNodeName("TransCode")
	private String transCode;
	@XMLNodeName("SENDID")
	private String sendId;
	@XMLNodeName("SENDDATE")
	private Date sendDate;
	@XMLNodeName("SENDSN")
	private String sendSn;
	@XMLNodeName("FILENAME")
	private String fileName;
	@XMLNodeName("Branch")
	private String branch;
	@XMLNodeName("SubBranch")
	private String subBranch;
	@XMLNodeName("OperatorId")
	private String operatorId;
	@XMLNodeName("CHANNELCODE")
	private String channelCode;
	private String channelId;

	public String getChannelCode() {
		return channelCode;
	}

	public void setChannelCode(String channelCode) {
		this.channelCode = channelCode;
	}

	private List<BatchSendSMSNotifyInfoVO> infos = new ArrayList<BatchSendSMSNotifyInfoVO>();

	public List<BatchSendSMSNotifyInfoVO> getInfos() {
		return infos;
	}

	public void setInfos(List<BatchSendSMSNotifyInfoVO> infos) {
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
