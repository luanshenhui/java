/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.hepowdhc.dcapp.modules.workflow.entity;

import org.hibernate.validator.constraints.Length;

import com.thinkgem.jeesite.common.persistence.DataEntity;

/**
 * 工作流节点Entity
 * 
 * @author ThinkGem
 * @version 2016-11-22
 */
public class DcaWorkflowTask extends DataEntity<DcaWorkflowTask> {

	private static final long serialVersionUID = 1L;
	private String uuid; // UUID
	private String taskName; // 节点名称
	private String wfId; // 工作流ID
	private String bizTaskId; // 业务节点ID。用&ldquo;||&rdquo;分割
	private String powerId; // 权力ID;VIA.DCA_WORKFLOW_MODULE
	private String bizRoleId; // 业务角色ID;多选,逗号隔开
	private Long sort; // 节点排序
	private String createPerson; // 创建人
	private String updatePerson; // 更新者
	private String isShow; // 是否启用.0:停止；1：启用
	private String preNodeId; // 首节点固定置为“-11111”
	private String nextNodeId; // 尾节点固定置为“-99999”

	public DcaWorkflowTask() {
		super();
	}

	public DcaWorkflowTask(String id) {
		super(id);
	}

	@Length(min = 1, max = 50, message = "UUID长度必须介于 1 和 50 之间")
	public String getUuid() {
		return uuid;
	}

	public void setUuid(String uuid) {
		this.uuid = uuid;
	}

	@Length(min = 0, max = 30, message = "节点名称长度必须介于 0 和 30 之间")
	public String getTaskName() {
		return taskName;
	}

	public void setTaskName(String taskName) {
		this.taskName = taskName;
	}

	@Length(min = 0, max = 50, message = "工作流ID长度必须介于 0 和 50 之间")
	public String getWfId() {
		return wfId;
	}

	public void setWfId(String wfId) {
		this.wfId = wfId;
	}

	@Length(min = 0, max = 16, message = "业务节点ID长度必须介于 0 和 16 之间")
	public String getBizTaskId() {
		return bizTaskId;
	}

	public void setBizTaskId(String bizTaskId) {
		this.bizTaskId = bizTaskId;
	}

	@Length(min = 0, max = 16, message = "权力ID长度必须介于 0 和 16 之间")
	public String getPowerId() {
		return powerId;
	}

	public void setPowerId(String powerId) {
		this.powerId = powerId;
	}

	@Length(min = 0, max = 333, message = "业务角色ID长度必须介于 0 和 333 之间")
	public String getBizRoleId() {
		return bizRoleId;
	}

	public void setBizRoleId(String bizRoleId) {
		this.bizRoleId = bizRoleId;
	}

	public Long getSort() {
		return sort;
	}

	public void setSort(Long sort) {
		this.sort = sort;
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

	@Length(min = 0, max = 2000, message = "0:停止；1：启用长度必须介于 0 和 2 之间")
	public String getIsShow() {
		return isShow;
	}

	public void setIsShow(String isShow) {
		this.isShow = isShow;
	}

	public String getPreNodeId() {
		return preNodeId;
	}

	public void setPreNodeId(String preNodeId) {
		this.preNodeId = preNodeId;
	}

	public String getNextNodeId() {
		return nextNodeId;
	}

	public void setNextNodeId(String nextNodeId) {
		this.nextNodeId = nextNodeId;
	}

}