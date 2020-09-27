package com.netctoss.account.entity;

import java.sql.Date;

public class Account{
	private Integer id;
	private Integer recommenderId;
	private String loginName;
	private String loginPassword;
	private String status;
	private Date createDate;
	private Date pauseDate;
	private Date closeDate;
	private String realName;
	private String idcardNo;
	private Date birthDate;
	private String gendar;
	private String occupation;
	private String telephone;
	private String email;
	private String mailaddress;
	private String zipcode;
	private String qq;
	private Date lastLoginTime;
	private String lastLoginIp;
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public Integer getRecommenderId() {
		return recommenderId;
	}
	public void setRecommenderId(Integer recommenderId) {
		this.recommenderId = recommenderId;
	}
	public String getLoginName() {
		return loginName;
	}
	public void setLoginName(String loginName) {
		this.loginName = loginName;
	}
	public String getLoginPassword() {
		return loginPassword;
	}
	public void setLoginPassword(String loginPassword) {
		this.loginPassword = loginPassword;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public Date getCreateDate() {
		return createDate;
	}
	public void setCreateDate(Date createDate) {
		this.createDate = createDate;
	}
	public Date getPauseDate() {
		return pauseDate;
	}
	public void setPauseDate(Date pauseDate) {
		this.pauseDate = pauseDate;
	}
	public Date getCloseDate() {
		return closeDate;
	}
	public void setCloseDate(Date closeDate) {
		this.closeDate = closeDate;
	}
	public String getRealName() {
		return realName;
	}
	public void setRealName(String realName) {
		this.realName = realName;
	}
	public String getIdcardNo() {
		return idcardNo;
	}
	public void setIdcardNo(String idcardNo) {
		this.idcardNo = idcardNo;
	}
	public Date getBirthDate() {
		return birthDate;
	}
	public void setBirthDate(Date birthDate) {
		this.birthDate = birthDate;
	}
	public String getGendar() {
		return gendar;
	}
	public void setGendar(String gendar) {
		this.gendar = gendar;
	}
	public String getOccupation() {
		return occupation;
	}
	public void setOccupation(String occupation) {
		this.occupation = occupation;
	}
	public String getTelephone() {
		return telephone;
	}
	public void setTelephone(String telephone) {
		this.telephone = telephone;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public String getMailaddress() {
		return mailaddress;
	}
	public void setMailaddress(String mailaddress) {
		this.mailaddress = mailaddress;
	}
	public String getZipcode() {
		return zipcode;
	}
	public void setZipcode(String zipcode) {
		this.zipcode = zipcode;
	}
	public String getQq() {
		return qq;
	}
	public void setQq(String qq) {
		this.qq = qq;
	}
	public Date getLastLoginTime() {
		return lastLoginTime;
	}
	public void setLastLoginTime(Date lastLoginTime) {
		this.lastLoginTime = lastLoginTime;
	}
	public String getLastLoginIp() {
		return lastLoginIp;
	}
	public void setLastLoginIp(String lastLoginIp) {
		this.lastLoginIp = lastLoginIp;
	}
	@Override
	public String toString() {
		return "Account [birthDate=" + birthDate + ", closeDate=" + closeDate
				+ ", createDate=" + createDate + ", email=" + email
				+ ", gendar=" + gendar + ", id=" + id + ", idcardNo="
				+ idcardNo + ", lastLoginIp=" + lastLoginIp
				+ ", lastLoginTime=" + lastLoginTime + ", loginName="
				+ loginName + ", loginPassword=" + loginPassword
				+ ", mailaddress=" + mailaddress + ", occupation=" + occupation
				+ ", pauseDate=" + pauseDate + ", qq=" + qq + ", realName="
				+ realName + ", recommenderId=" + recommenderId + ", status="
				+ status + ", telephone=" + telephone + ", zipcode=" + zipcode
				+ "]";
	}
	
}
