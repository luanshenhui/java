/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.hepowdhc.dcapp.modules.visualization.entity;

import java.util.List;

import com.thinkgem.jeesite.common.persistence.DataEntity;
import com.thinkgem.jeesite.modules.sys.entity.DcaTraceUserRole;

/**
 * DcaReportAlarmMsgEntity
 * 
 * @author hunan
 * @version 2016-11-08
 */
public class DcaReportAlarmMsg extends DataEntity<DcaReportAlarmMsg> {

	private static final long serialVersionUID = 1L;

	//告警信息表主键
	private String detailId;
	//业务实例id
	private String NO;
	//业务实例名称
	private String flowName;
	//业务操作人
	private String operPerson;
	//业务操作人所属部门
	private String operPost;
	//办理事项
	private String dataName;
	//告警级别
	private String alarmLevel;
	//告警状态
	private String alarmStatus;
	//告警信息
	private String alarmMsg;
	//登录人所属部门id
	private String loginOfficeId;

	/**
	 * 业务类型（三重一大、投资、担保）
	 */
	private String idxDataType;
	public String getIdxDataType() {
		return idxDataType;
	}

	public void setIdxDataType(String idxDataType) {
		this.idxDataType = idxDataType;
	}
	
	// 登录人所在岗位
	private List<DcaTraceUserRole> postList;
	
	public DcaReportAlarmMsg() {
		super();
	}

	public DcaReportAlarmMsg(String id) {
		super(id);
	}

	// 定义变量的getting和setting
	public String getDetailId() {
		return detailId;
	}
	public void setDetailId(String detailId) {
		this.detailId = detailId;
	}
	public String getNO() {
		return NO;
	}
	public void setNO(String nO) {
		this.NO = nO;
	}
	public String getFlowName() {
		return flowName;
	}
	public void setFlowName(String flowName) {
		this.flowName = flowName;
	}
	public String getOperPerson() {
		return operPerson;
	}
	public void setOperPerson(String operPerson) {
		this.operPerson = operPerson;
	}
	public String getOperPost() {
		return operPost;
	}
	public void setOperPost(String operPost) {
		this.operPost = operPost;
	}
	public String getDataName() {
		return dataName;
	}
	public void setDataName(String dataName) {
		this.dataName = dataName;
	}
	public String getAlarmLevel() {
		return alarmLevel;
	}
	public void setAlarmLevel(String alarmLevel) {
		this.alarmLevel = alarmLevel;
	}
	public String getAlarmStatus() {
		return alarmStatus;
	}
	public void setAlarmStatus(String alarmStatus) {
		this.alarmStatus = alarmStatus;
	}
	public String getAlarmMsg() {
		return alarmMsg;
	}
	public void setAlarmMsg(String alarmMsg) {
		this.alarmMsg = alarmMsg;
	}
	
	public String getLoginOfficeId() {
		return loginOfficeId;
	}
	public void setLoginOfficeId(String loginOfficeId) {
		this.loginOfficeId = loginOfficeId;
	}

	public List<DcaTraceUserRole> getPostList() {
		return postList;
	}

	public void setPostList(List<DcaTraceUserRole> postList) {
		this.postList = postList;
	}
	
}