package com.netctoss.service.entity;

import java.sql.*;

/**
 * service_heyanguang 实体类 Wed Jan 25 17:35:30 CST 2012 hyg
 */

public class Service {
	private Integer id;
	private Integer accountId;
	private String unixHost;
	private String osUsername;
	private String loginPasswd;
	private String status;
	private Date createDate;
	private Date pauseDate;
	private Date closeDate;
	private Integer costId;

	public void setId(Integer id) {
		this.id = id;
	}

	public Integer getId() {
		return id;
	}

	public void setAccountId(Integer accountId) {
		this.accountId = accountId;
	}

	public Integer getAccountId() {
		return accountId;
	}

	public void setUnixHost(String unixHost) {
		this.unixHost = unixHost;
	}

	public String getUnixHost() {
		return unixHost;
	}

	public void setOsUsername(String osUsername) {
		this.osUsername = osUsername;
	}

	public String getOsUsername() {
		return osUsername;
	}

	public void setLoginPasswd(String loginPasswd) {
		this.loginPasswd = loginPasswd;
	}

	public String getLoginPasswd() {
		return loginPasswd;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getStatus() {
		return status;
	}

	public void setCreateDate(Date createDate) {
		this.createDate = createDate;
	}

	public Date getCreateDate() {
		return createDate;
	}

	public void setPauseDate(Date pauseDate) {
		this.pauseDate = pauseDate;
	}

	public Date getPauseDate() {
		return pauseDate;
	}

	public void setCloseDate(Date closeDate) {
		this.closeDate = closeDate;
	}

	public Date getCloseDate() {
		return closeDate;
	}

	public void setCostId(Integer costId) {
		this.costId = costId;
	}

	public Integer getCostId() {
		return costId;
	}
}
