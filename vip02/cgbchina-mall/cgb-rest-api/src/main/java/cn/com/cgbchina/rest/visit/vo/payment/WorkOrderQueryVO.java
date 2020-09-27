package cn.com.cgbchina.rest.visit.vo.payment;

import java.io.Serializable;

import cn.com.cgbchina.rest.common.annotation.XMLNodeName;
import cn.com.cgbchina.rest.visit.vo.BaseQueryVo;

/**
 * Comment: Created by 11150321050126 on 2016/4/29.
 */
public class WorkOrderQueryVO extends BaseQueryVo implements Serializable {
	@XMLNodeName("CASEID")
	private String caseID;
	@XMLNodeName("SRCCASEID")
	private String srcCaseId;
	@XMLNodeName("CHANNEL")
	private String channel;

	public String getCaseID() {
		return caseID;
	}

	public String getSrcCaseId() {
		return srcCaseId;
	}

	public String getChannel() {
		return channel;
	}

	public void setCaseID(String caseID) {
		this.caseID = caseID;
	}

	public void setSrcCaseId(String srcCaseId) {
		this.srcCaseId = srcCaseId;
	}

	public void setChannel(String channel) {
		this.channel = channel;
	}
}
