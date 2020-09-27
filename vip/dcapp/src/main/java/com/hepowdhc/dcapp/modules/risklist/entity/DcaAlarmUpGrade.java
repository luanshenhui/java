/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.hepowdhc.dcapp.modules.risklist.entity;

import org.hibernate.validator.constraints.Length;

import com.thinkgem.jeesite.common.persistence.DataEntity;

/**
 * 告警上报管理Entity
 * @author dhc
 * @version 2016-11-15
 */
public class DcaAlarmUpGrade extends DataEntity<DcaAlarmUpGrade> {
	
	private static final long serialVersionUID = 1L;
	private String uuid;		// id
	private String powerId;		// 权力id
	private String bizRoleId;		// 业务角色
	private String alarmLevel;		// 告警级别
	private String sumOutTime;		// 累计超期时间（小时）
	private String gradeOrgPost;		// 上报部门岗位
	private String createPerson;		// 创建人
	private String updatePerson;		// 更新者
	
	private String remarksNew;		// 备注说明
	private String bizRoleName;		// 业务角色名称
	private String gradeOrgPostName; // 上报岗位名称
	private String powerName;		// 权力名称
	private String alarmLevelName;	// 告警级别名称
	private String sumOutTimeName;	// 累计超期时间（小时）显示
	
	private String gradeOrgPostOld;	// 修改前上报部门岗位
	
	private String orgName;
	
	public DcaAlarmUpGrade() {
		super();
	}

	public DcaAlarmUpGrade(String id){
		super(id);
	}

	@Length(min=0, max=50, message="uuid长度必须介于 0 和 50 之间")
	public String getUuid() {
		return uuid;
	}

	public void setUuid(String uuid) {
		this.uuid = uuid;
	}
	
	@Length(min=0, max=5, message="权力id长度必须介于 0 和 5 之间")
	public String getPowerId() {
		return powerId;
	}

	public void setPowerId(String powerId) {
		this.powerId = powerId;
	}
	
	@Length(min=0, max=50, message="业务角色长度必须介于 0 和 50 之间")
	public String getBizRoleId() {
		return bizRoleId;
	}

	public void setBizRoleId(String bizRoleId) {
		this.bizRoleId = bizRoleId;
	}
	
	@Length(min=0, max=5, message="告警级别长度必须介于 0 和 5 之间")
	public String getAlarmLevel() {
		return alarmLevel;
	}

	public void setAlarmLevel(String alarmLevel) {
		this.alarmLevel = alarmLevel;
	}
	
	@Length(min=0, max=8, message="累计超期时间长度必须介于 0 和 8之间")
	public String getSumOutTime() {
		return sumOutTime;
	}

	public void setSumOutTime(String sumOutTime) {
		this.sumOutTime = sumOutTime;
	}
	
	@Length(min=0, max=1000, message="上报部门岗位长度必须介于 0 和 1000 之间")
	public String getGradeOrgPost() {
		return gradeOrgPost;
	}

	public void setGradeOrgPost(String gradeOrgPost) {
		this.gradeOrgPost = gradeOrgPost;
	}
	
	@Length(min=0, max=64, message="创建人长度必须介于 0 和 64 之间")
	public String getCreatePerson() {
		return createPerson;
	}

	public void setCreatePerson(String createPerson) {
		this.createPerson = createPerson;
	}
	
	@Length(min=0, max=64, message="更新者长度必须介于 0 和 64 之间")
	public String getUpdatePerson() {
		return updatePerson;
	}

	public void setUpdatePerson(String updatePerson) {
		this.updatePerson = updatePerson;
	}

	@Length(min=0, max=200, message="备注说明长度必须介于 0 和 200之间")
	public String getRemarksNew() {
		return remarksNew;
	}

	public void setRemarksNew(String remarksNew) {
		this.remarksNew = remarksNew;
	}

	public String getBizRoleName() {
		return bizRoleName;
	}

	public void setBizRoleName(String bizRoleName) {
		this.bizRoleName = bizRoleName;
	}

	public String getGradeOrgPostName() {
		return gradeOrgPostName;
	}

	public void setGradeOrgPostName(String gradeOrgPostName) {
		this.gradeOrgPostName = gradeOrgPostName;
	}

	public String getPowerName() {
		return powerName;
	}

	public void setPowerName(String powerName) {
		this.powerName = powerName;
	}

	public String getAlarmLevelName() {
		return alarmLevelName;
	}

	public void setAlarmLevelName(String alarmLevelName) {
		this.alarmLevelName = alarmLevelName;
	}

	public String getSumOutTimeName() {
		return sumOutTimeName;
	}

	public void setSumOutTimeName(String sumOutTimeName) {
		this.sumOutTimeName = sumOutTimeName;
	}

	public String getGradeOrgPostOld() {
		return gradeOrgPostOld;
	}

	public void setGradeOrgPostOld(String gradeOrgPostOld) {
		this.gradeOrgPostOld = gradeOrgPostOld;
	}

	public String getOrgName() {
		return orgName;
	}

	public void setOrgName(String orgName) {
		this.orgName = orgName;
	}
	
}