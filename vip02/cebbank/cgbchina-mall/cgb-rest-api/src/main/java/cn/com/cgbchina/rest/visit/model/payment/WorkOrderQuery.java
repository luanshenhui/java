package cn.com.cgbchina.rest.visit.model.payment;

import cn.com.cgbchina.rest.visit.model.BaseQuery;

import java.io.Serializable;

import javax.validation.constraints.NotNull;

/**
 * Comment: Created by 11150321050126 on 2016/4/29.
 */
public class WorkOrderQuery extends BaseQuery implements Serializable {
	private static final long serialVersionUID = 635448586142315766L;
	private String caseID;
	private String srcCaseId;
	@NotNull
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
