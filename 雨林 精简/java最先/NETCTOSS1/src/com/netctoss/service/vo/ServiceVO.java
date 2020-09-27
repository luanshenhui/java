package com.netctoss.service.vo;

import java.sql.Date;
/**
 * 业务帐号VO，用于封装关联查询后的结果。
 * 仅仅是在查询时使用，持久化时还是用原来的Service
 * @author soft01
 *
 */
public class ServiceVO {
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
	
	private String idcardNo;
	private String realName;
	
	private String costName;
	private String descr;
	
	

	public String getIdcardNo() {
		return idcardNo;
	}

	public void setIdcardNo(String idcardNo) {
		this.idcardNo = idcardNo;
	}

	public String getRealName() {
		return realName;
	}

	public void setRealName(String realName) {
		this.realName = realName;
	}

	public String getCostName() {
		return costName;
	}

	public void setCostName(String costName) {
		this.costName = costName;
	}

	public String getDescr() {
		return descr;
	}

	public void setDescr(String descr) {
		this.descr = descr;
	}

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

	@Override
	public String toString() {
		return "ServiceVO [accountId=" + accountId + ", closeDate=" + closeDate
				+ ", costId=" + costId + ", costName=" + costName
				+ ", createDate=" + createDate + ", descr=" + descr + ", id="
				+ id + ", idcardNo=" + idcardNo + ", loginPasswd="
				+ loginPasswd + ", osUsername=" + osUsername + ", pauseDate="
				+ pauseDate + ", realName=" + realName + ", status=" + status
				+ ", unixHost=" + unixHost + "]";
	}
	
	
}
