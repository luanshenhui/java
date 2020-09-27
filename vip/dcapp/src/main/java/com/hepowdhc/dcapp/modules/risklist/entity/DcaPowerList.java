/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.hepowdhc.dcapp.modules.risklist.entity;
		

import java.util.Date;

import org.hibernate.validator.constraints.Length;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.thinkgem.jeesite.common.persistence.DataEntity;
import com.thinkgem.jeesite.common.utils.excel.annotation.ExcelField;

/**
 * 单表查询Entity
 * @author liunan
 * @version 2016-11-09
 */
public class DcaPowerList extends DataEntity<DcaPowerList> {
	
	private static final long serialVersionUID = 1L;
	private String uuid;		// 业务角色
	private String bizRoleName;		// 业务角色名称
	private String powerId;		// 权力
	private String accord;		// 设定依据
	private String duty;		// 责任事项
	private String createPerson;		// 创建者
	private String updatePerson;		// 更新者
	private String remarks;
	private String name;	//岗位名称
	private String bizRoleId;		// 业务角色Id
	private String flag;
	private String Num;
	
	@ExcelField(title="权力", align=2, sort=10)
	public String getNum() {
		return Num;
	}

	public void setNum(String num) {
		Num = num;
	}

	public String getFlag() {
		return flag;
	}

	public void setFlag(String flag) {
		this.flag = flag;
	}

	public DcaPowerList() {
		super();
	}

	public DcaPowerList(String id){
		super(id);
	}

	@Length(min=1, max=50, message="业务角色长度必须介于 1 和 50 之间")
	public String getUuid() {
		return uuid;
	}

	public void setUuid(String uuid) {
		this.uuid = uuid;
	}
	
	@Length(min=0, max=30, message="业务角色名称长度必须介于 0 和 100 之间")
	@ExcelField(title="业务角色", align=2, sort=40)
	public String getBizRoleName() {
		return bizRoleName;
	}

	public void setBizRoleName(String bizRoleName) {
		this.bizRoleName = bizRoleName;
	}
	
	@Length(min=0, max=5, message="权力长度必须介于 0 和 5 之间")
	@ExcelField(title="权力", align=2, sort=20)
	public String getPowerId() {
		return powerId;
	}

	public void setPowerId(String powerId) {
		this.powerId = powerId;
	}
	
	@Length(min=0, max=500, message="设定依据长度必须介于 0 和 2000 之间")
	@ExcelField(title="设定依据", align=2, sort=30)
	public String getAccord() {
		return accord;
	}

	public void setAccord(String accord) {
		this.accord = accord;
	}
	
	@Length(min=0, max=100, message="责任事项长度必须介于 0 和 2000 之间")
	@ExcelField(title="责任事项", align=2, sort=50)
	public String getDuty() {
		return duty;
	}

	public void setDuty(String duty) {
		this.duty = duty;
	}
	
	@Length(min=0, max=200, message="关联岗位长度必须介于 0 和200 之间")
	@ExcelField(title="关联岗位", align=2, sort=60)
	public String getRemarks() {
		return remarks;
	}

	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}

	@Length(min=0, max=64, message="创建者长度必须介于 0 和 64 之间")
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
	
	private Date createDate;
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	public Date getCreateDate() {
		return createDate;
	}

	public void setCreateDate(Date createDate) {
		this.createDate = createDate;
	}
	
	private Date updateDate;
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	public Date getUpdateDate() {
		return updateDate;
	}

	public void setUpdateDate(Date updateDate) {
		this.updateDate = updateDate;
	}
	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}
	@Length(min=1, max=50, message="业务角色长度必须介于 1 和 50 之间")
	public String getBizRoleId() {
		return bizRoleId;
	}

	public void setBizRoleId(String bizRoleId) {
		this.bizRoleId = bizRoleId;
	}
	private String orgId;        //组织机构Id
	public String getOrgId() {
		return orgId;
	}

	public void setOrgId(String orgId) {
		this.orgId = orgId;
	}
	private String postId;      //岗位Id
	public String getPostId() {
		return postId;
	}

	public void setPostId(String postId) {
		this.postId = postId;
	}
	private String parentId;      //岗位Id
	public String getParentId() {
		return parentId;
	}

	public void setParentId(String parentId) {
		this.parentId = parentId;
	}
}