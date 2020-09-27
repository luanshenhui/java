/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.hepowdhc.dcapp.modules.riskmanage.entity;

import org.hibernate.validator.constraints.Length;

import com.thinkgem.jeesite.common.persistence.DataEntity;
import com.thinkgem.jeesite.modules.sys.entity.Office;
import com.thinkgem.jeesite.modules.sys.entity.User;

/**
 * 风险转发Entity
 * 
 * @author ThinkGem
 * @version 2016-11-22
 */
public class DcaRiskTrans extends DataEntity<DcaRiskTrans> {

	private static final long serialVersionUID = 1L;
	private String uuid; // ID
	private Office office; // 部门ID
	private String postId; // 岗位ID
	private User user; // 转发人ID
	private String riskManageId; // 风险管理ID
	private String createPerson; // 创建人
	private String updatePerson; // 更新者
	private String isDefinePower; // 是否有界定权限。0:否；1：是

	public String getIsDefinePower() {
		return isDefinePower;
	}

	public void setIsDefinePower(String isDefinePower) {
		this.isDefinePower = isDefinePower;
	}

	public DcaRiskTrans() {
		super();
	}

	public DcaRiskTrans(String id) {
		super(id);
	}

	@Length(min = 1, max = 50, message = "ID长度必须介于 1 和 50 之间")
	public String getUuid() {
		return uuid;
	}

	public void setUuid(String uuid) {
		this.uuid = uuid;
	}

	public Office getOffice() {
		return office;
	}

	public void setOffice(Office office) {
		this.office = office;
	}

	@Length(min = 0, max = 64, message = "岗位ID长度必须介于 0 和 64 之间")
	public String getPostId() {
		return postId;
	}

	public void setPostId(String postId) {
		this.postId = postId;
	}

	public User getUser() {
		return user;
	}

	public void setUser(User user) {
		this.user = user;
	}

	@Length(min = 0, max = 50, message = "风险管理ID长度必须介于 0 和 50 之间")
	public String getRiskManageId() {
		return riskManageId;
	}

	public void setRiskManageId(String riskManageId) {
		this.riskManageId = riskManageId;
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

}