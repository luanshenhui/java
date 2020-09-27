/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.hepowdhc.dcapp.modules.riskmanage.entity;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.thinkgem.jeesite.common.persistence.DataEntity;
import org.hibernate.validator.constraints.Length;

import java.util.Date;

/**
 * 风险管理Entity
 * 
 * @author zhengwei.cui
 * @version 2016-11-16
 */
public class DcaRiskManage extends DataEntity<DcaRiskManage> {

	private static final long serialVersionUID = 1L;
	private String riskManageId; // 风险管理id
	private String bizRoleId; // 业务角色id
	private String powerId; // 权力id
	private String riskId; // 风险清单id
	private String bizFlowId; // 业务实例id
	private String bizFlowName; // 业务实例名称
	private String bizOperPerson; // 业务操作人
	private String bizOperPost; // 业务操作人所属部门
	private String bizDataId; // 业务数据id
	private String bizDataName; // 业务数据名称
	private String instanceId; // 工作流id
	private String taskId; // 流程节点ID
	private String taskName; // 流程节点名
	private String alarmLevel; // 预警/风险级别
	private String alarmType; // 预警/风险维度
	private String riskLevel; // 风险等级
	private String cpuResult; // 运算结果
	private String riskMsg; // 风险信息
	private String riskTransFlag; // 风险转发标识 0-未转发 1-转发
	private String defineByManual; // 是否可以人工界定风险 0-否 1-是
	private String definePerson; // 界定人
	private String defineStatus; // 界定状态;数据字典
	private Date defineDate; // 界定时间
	private String evidence; // 界定材料;下载路径（完整URL）
	private String explains; // 补充说明
	private String createPerson; // 创建人
	private String updatePerson; // 更新者
	private String bizOperPostName; // 业务操作人所属部门名称
	private String bizOperPersonName; // 操作人名称

	private Integer powerNum; // 记录数
	private Integer month; // 月份
	private String powerName; // 权力名称

	private String postId; // 岗位id

	private String idxDataType; // 业务类型（三重一大、投资、担保）
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

	public String getPowerName() {
		return powerName;
	}

	public void setPowerName(String powerName) {
		this.powerName = powerName;
	}

	public Integer getPowerNum() {
		return powerNum;
	}

	public void setPowerNum(Integer powerNum) {
		this.powerNum = powerNum;
	}

	public Integer getMonth() {
		return month;
	}

	public void setMonth(Integer month) {
		this.month = month;
	}

	public String getBizOperPersonName() {
		return bizOperPersonName;
	}

	public void setBizOperPersonName(String bizOperPersonName) {
		this.bizOperPersonName = bizOperPersonName;
	}

	public String getBizOperPostName() {
		return bizOperPostName;
	}

	public void setBizOperPostName(String bizOperPostName) {
		this.bizOperPostName = bizOperPostName;
	}

	public DcaRiskManage() {
		super();
	}

	public DcaRiskManage(String id) {
		super(id);
	}

	public String getRiskManageId() {
		return riskManageId;
	}

	public void setRiskManageId(String riskManageId) {
		this.riskManageId = riskManageId;
	}

	@Length(min = 0, max = 50, message = "业务角色id长度必须介于 0 和 50 之间")
	public String getBizRoleId() {
		return bizRoleId;
	}

	public void setBizRoleId(String bizRoleId) {
		this.bizRoleId = bizRoleId;
	}

	@Length(min = 0, max = 5, message = "权力id长度必须介于 0 和 5 之间")
	public String getPowerId() {
		return powerId;
	}

	public void setPowerId(String powerId) {
		this.powerId = powerId;
	}

	@Length(min = 0, max = 50, message = "风险清单id长度必须介于 0 和 50 之间")
	public String getRiskId() {
		return riskId;
	}

	public void setRiskId(String riskId) {
		this.riskId = riskId;
	}

	@Length(min = 0, max = 50, message = "业务实例id长度必须介于 0 和 50 之间")
	public String getBizFlowId() {
		return bizFlowId;
	}

	public void setBizFlowId(String bizFlowId) {
		this.bizFlowId = bizFlowId;
	}

	@Length(min = 0, max = 100, message = "业务实例名称长度必须介于 0 和 100 之间")
	public String getBizFlowName() {
		return bizFlowName;
	}

	public void setBizFlowName(String bizFlowName) {
		this.bizFlowName = bizFlowName;
	}

	@Length(min = 0, max = 50, message = "业务操作人长度必须介于 0 和 50 之间")
	public String getBizOperPerson() {
		return bizOperPerson;
	}

	public void setBizOperPerson(String bizOperPerson) {
		this.bizOperPerson = bizOperPerson;
	}

	@Length(min = 0, max = 100, message = "业务操作人所属部门长度必须介于 0 和 100 之间")
	public String getBizOperPost() {
		return bizOperPost;
	}

	public void setBizOperPost(String bizOperPost) {
		this.bizOperPost = bizOperPost;
	}

	@Length(min = 0, max = 50, message = "业务数据id长度必须介于 0 和 50 之间")
	public String getBizDataId() {
		return bizDataId;
	}

	public void setBizDataId(String bizDataId) {
		this.bizDataId = bizDataId;
	}

	@Length(min = 0, max = 100, message = "业务数据名称长度必须介于 0 和 100 之间")
	public String getBizDataName() {
		return bizDataName;
	}

	public void setBizDataName(String bizDataName) {
		this.bizDataName = bizDataName;
	}

	@Length(min = 0, max = 50, message = "工作流id长度必须介于 0 和 50 之间")
	public String getInstanceId() {
		return instanceId;
	}

	public void setInstanceId(String instanceId) {
		this.instanceId = instanceId;
	}

	@Length(min = 0, max = 50, message = "流程节点ID长度必须介于 0 和 50 之间")
	public String getTaskId() {
		return taskId;
	}

	public void setTaskId(String taskId) {
		this.taskId = taskId;
	}

	@Length(min = 0, max = 100, message = "流程节点名长度必须介于 0 和 100 之间")
	public String getTaskName() {
		return taskName;
	}

	public void setTaskName(String taskName) {
		this.taskName = taskName;
	}

	@Length(min = 0, max = 5, message = "预警/风险级别长度必须介于 0 和 5 之间")
	public String getAlarmLevel() {
		return alarmLevel;
	}

	public void setAlarmLevel(String alarmLevel) {
		this.alarmLevel = alarmLevel;
	}

	@Length(min = 0, max = 5, message = "预警/风险维度长度必须介于 0 和 5 之间")
	public String getAlarmType() {
		return alarmType;
	}

	public void setAlarmType(String alarmType) {
		this.alarmType = alarmType;
	}

	@Length(min = 0, max = 5, message = "风险等级长度必须介于 0 和 5 之间")
	public String getRiskLevel() {
		return riskLevel;
	}

	public void setRiskLevel(String riskLevel) {
		this.riskLevel = riskLevel;
	}

	@Length(min = 0, max = 500, message = "运算结果长度必须介于 0 和 500 之间")
	public String getCpuResult() {
		return cpuResult;
	}

	public void setCpuResult(String cpuResult) {
		this.cpuResult = cpuResult;
	}

	@Length(min = 0, max = 255, message = "风险信息长度必须介于 0 和 255 之间")
	public String getRiskMsg() {
		return riskMsg;
	}

	public void setRiskMsg(String riskMsg) {
		this.riskMsg = riskMsg;
	}

	@Length(min = 0, max = 5, message = "风险转发标识 0-未转发 1-转发长度必须介于 0 和 5 之间")
	public String getRiskTransFlag() {
		return riskTransFlag;
	}

	public void setRiskTransFlag(String riskTransFlag) {
		this.riskTransFlag = riskTransFlag;
	}

	@Length(min = 0, max = 5, message = "是否可以人工界定风险 0-否 1-是长度必须介于 0 和 5 之间")
	public String getDefineByManual() {
		return defineByManual;
	}

	public void setDefineByManual(String defineByManual) {
		this.defineByManual = defineByManual;
	}

	@Length(min = 0, max = 64, message = "界定人长度必须介于 0 和 64 之间")
	public String getDefinePerson() {
		return definePerson;
	}

	public void setDefinePerson(String definePerson) {
		this.definePerson = definePerson;
	}

	@Length(min = 0, max = 5, message = "界定状态;数据字典长度必须介于 0 和 5 之间")
	public String getDefineStatus() {
		return defineStatus;
	}

	public void setDefineStatus(String defineStatus) {
		this.defineStatus = defineStatus;
	}

	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	public Date getDefineDate() {
		return defineDate;
	}

	public void setDefineDate(Date defineDate) {
		this.defineDate = defineDate;
	}

	@Length(min = 0, max = 2000, message = "界定材料;下载路径（完整URL）长度必须介于 0 和 2000 之间")
	public String getEvidence() {
		return evidence;
	}

	public void setEvidence(String evidence) {
		this.evidence = evidence;
	}

	@Length(min = 0, max = 500, message = "补充说明长度必须介于 0 和 500 之间")
	public String getExplains() {
		return explains;
	}

	public void setExplains(String explains) {
		this.explains = explains;
	}

	@Length(min = 0, max = 64, message = "创建人长度必须介于 0 和 64 之间")
	public String getCreatePerson() {
		return createPerson;
	}

	public void setCreatePerson(String createPerson) {
		this.createPerson = createPerson;
	}

	@Length(min = 0, max = 64, message = "更新者长度必须介于 0 和 64 之间")
	public String getUpdatePerson() {
		return updatePerson;
	}

	public void setUpdatePerson(String updatePerson) {
		this.updatePerson = updatePerson;
	}

	private String isDefinePower; // 是否有界定权限。

	public String getIsDefinePower() {
		return isDefinePower;
	}

	public void setIsDefinePower(String isDefinePower) {
		this.isDefinePower = isDefinePower;
	}

	/**
	 * 部门父id，为取部门全路径
	 */
	private String parentIds;

	public String getParentIds() {
		return parentIds;
	}

	public void setParentIds(String parentIds) {
		this.parentIds = parentIds;
	}

}