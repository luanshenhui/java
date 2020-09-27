package com.dpn.ciqqlc.standard.model;

/**
 * 用户访问配置DTO
 * @author Administrator
 *
 */
public class UserConfigurationDTO {
	
	
	private String id;	
	private String userId;
	private String visitId;
	private String orderBy;
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public String getVisitId() {
		return visitId;
	}
	public void setVisitId(String visitId) {
		this.visitId = visitId;
	}
	public String getOrderBy() {
		return orderBy;
	}
	public void setOrderBy(String orderBy) {
		this.orderBy = orderBy;
	}
	
	

}
