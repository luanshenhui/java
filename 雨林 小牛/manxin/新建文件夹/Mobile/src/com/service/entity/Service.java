package com.service.entity;

import java.util.Date;

public class Service {
	private int id;
	private int account_id;
	private String unix_host;
	private String os_username;
	private String login_passwd;
	private String status;
	private Date create_date;
	private Date pause_date;
	private Date close_date;
	private int cost_id;
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public int getAccount_id() {
		return account_id;
	}
	public void setAccount_id(int accountId) {
		account_id = accountId;
	}
	public String getUnix_host() {
		return unix_host;
	}
	public void setUnix_host(String unixHost) {
		unix_host = unixHost;
	}
	public String getOs_username() {
		return os_username;
	}
	public void setOs_username(String osUsername) {
		os_username = osUsername;
	}
	public String getLogin_passwd() {
		return login_passwd;
	}
	public void setLogin_passwd(String loginPasswd) {
		login_passwd = loginPasswd;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public Date getCreate_date() {
		return create_date;
	}
	public void setCreate_date(Date createDate) {
		create_date = createDate;
	}
	public Date getPause_date() {
		return pause_date;
	}
	public void setPause_date(Date pauseDate) {
		pause_date = pauseDate;
	}
	public Date getClose_date() {
		return close_date;
	}
	public void setClose_date(Date closeDate) {
		close_date = closeDate;
	}
	public int getCost_id() {
		return cost_id;
	}
	public void setCost_id(int costId) {
		cost_id = costId;
	}
	public Service() {
		super();
		// TODO Auto-generated constructor stub
	}
	public Service(int id, int accountId, String unixHost, String osUsername,
			String loginPasswd, String status, Date createDate, Date pauseDate,
			Date closeDate, int costId) {
		super();
		this.id = id;
		account_id = accountId;
		unix_host = unixHost;
		os_username = osUsername;
		login_passwd = loginPasswd;
		this.status = status;
		create_date = createDate;
		pause_date = pauseDate;
		close_date = closeDate;
		cost_id = costId;
	}
	@Override
	public String toString() {
		return "Service [account_id=" + account_id + ", close_date="
				+ close_date + ", cost_id=" + cost_id + ", create_date="
				+ create_date + ", id=" + id + ", login_passwd=" + login_passwd
				+ ", os_username=" + os_username + ", pause_date=" + pause_date
				+ ", status=" + status + ", unix_host=" + unix_host + "]";
	}
	
}
