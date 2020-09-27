/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.hepowdhc.dcapp.modules.visualization.entity;

import com.thinkgem.jeesite.common.persistence.DataEntity;

public class DcaReportRiskMes extends DataEntity<DcaReportRiskMes> {

	private static final long serialVersionUID = 1L;
	// 业务实例名称 业务事项
	private String bizFlowName;
	// 业务操作人 操作人
	private String bizOperPerson;
	// 业务操作人所属部门 所属部门
	private String bizOperPost;
	// 业务数据名称 办理事项
	private String bizDataName;
	// 风险等级
	private String riskLevel;
	// 风险信息 风险内容
	private String riskMsg;
	// 界定人
	private String definePerson;
	// 界定状态
	private String defineStatus;
	// 当前登录人的id
	private String loginId;
	// 岗位id
	private String postId;
	// 业务类型（三重一大、投资、担保）
	private String idxDataType;
	public String getIdxDataType() {
		return idxDataType;
	}

	public void setIdxDataType(String idxDataType) {
		this.idxDataType = idxDataType;
	}

	public String getPostId() {
		return postId;
	}

	public void setPostId(String postId) {
		this.postId = postId;
	}

	public String getBizFlowName() {
		return bizFlowName;
	}

	public void setBizFlowName(String bizFlowName) {
		this.bizFlowName = bizFlowName;
	}

	public String getBizOperPerson() {
		return bizOperPerson;
	}

	public void setBizOperPerson(String bizOperPerson) {
		this.bizOperPerson = bizOperPerson;
	}

	public String getBizOperPost() {
		return bizOperPost;
	}

	public void setBizOperPost(String bizOperPost) {
		this.bizOperPost = bizOperPost;
	}

	public String getBizDataName() {
		return bizDataName;
	}

	public void setBizDataName(String bizDataName) {
		this.bizDataName = bizDataName;
	}

	public String getRiskLevel() {
		return riskLevel;
	}

	public void setRiskLevel(String riskLevel) {
		this.riskLevel = riskLevel;
	}

	public String getRiskMsg() {
		return riskMsg;
	}

	public void setRiskMsg(String riskMsg) {
		this.riskMsg = riskMsg;
	}

	public String getDefinePerson() {
		return definePerson;
	}

	public void setDefinePerson(String definePerson) {
		this.definePerson = definePerson;
	}

	public String getDefineStatus() {
		return defineStatus;
	}

	public void setDefineStatus(String defineStatus) {
		this.defineStatus = defineStatus;
	}

	public String getLoginId() {
		return loginId;
	}

	public void setLoginId(String loginId) {
		this.loginId = loginId;
	}

}