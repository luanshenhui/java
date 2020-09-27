package com.dpn.ciqqlc.standard.model;

import java.util.Date;

/**
 * 用户访问配置DTO
 * @author Administrator
 *
 */
public class VisitConfigurationDTO {
	
	private String id;	
	private String orderBy;
	private String name;
	private String code;
	private String path;
	private Date createTime;
	private String createUser;
	private String localWebType;//默认是0本系统 1是web系统 有待扩展
	
	
	private String userId;
	
	public String getLocalWebType() {
		return localWebType;
	}
	public void setLocalWebType(String localWebType) {
		this.localWebType = localWebType;
	}
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getOrderBy() {
		return orderBy;
	}
	public void setOrderBy(String orderBy) {
		this.orderBy = orderBy;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getCode() {
		return code;
	}
	public void setCode(String code) {
		this.code = code;
	}
	public String getPath() {
		return path;
	}
	public void setPath(String path) {
		this.path = path;
	}
	public Date getCreateTime() {
		return createTime;
	}
	public void setCreateTime(Date createTime) {
		this.createTime = createTime;
	}
	public String getCreateUser() {
		return createUser;
	}
	public void setCreateUser(String createUser) {
		this.createUser = createUser;
	}

	
}
