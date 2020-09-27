package com.service.entity;

import java.util.Date;

public class VO {
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
	private String idcard_no;
	private String real_name;
	private String name;
	private String descr;
	
	public String getDescr() {
		return descr;
	}
	public void setDescr(String descr) {
		this.descr = descr;
	}
	public String getReal_name() {
		return real_name;
	}
	public void setReal_name(String realName) {
		real_name = realName;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getIdcard_no() {
		return idcard_no;
	}
	public void setIdcard_no(String idcardNo) {
		idcard_no = idcardNo;
	}
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
	public VO() {
		super();
		// TODO Auto-generated constructor stub
	}
	public VO(int id, int accountId, String unixHost, String osUsername,
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
		return "VO [account_id=" + account_id + ", close_date=" + close_date
				+ ", cost_id=" + cost_id + ", create_date=" + create_date
				+ ", id=" + id + ", login_passwd=" + login_passwd
				+ ", os_username=" + os_username + ", pause_date=" + pause_date
				+ ", status=" + status + ", unix_host=" + unix_host + "]";
	}
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + account_id;
		result = prime * result
				+ ((close_date == null) ? 0 : close_date.hashCode());
		result = prime * result + cost_id;
		result = prime * result
				+ ((create_date == null) ? 0 : create_date.hashCode());
		result = prime * result + id;
		result = prime * result
				+ ((login_passwd == null) ? 0 : login_passwd.hashCode());
		result = prime * result
				+ ((os_username == null) ? 0 : os_username.hashCode());
		result = prime * result
				+ ((pause_date == null) ? 0 : pause_date.hashCode());
		result = prime * result + ((status == null) ? 0 : status.hashCode());
		result = prime * result
				+ ((unix_host == null) ? 0 : unix_host.hashCode());
		return result;
	}
	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		VO other = (VO) obj;
		if (account_id != other.account_id)
			return false;
		if (close_date == null) {
			if (other.close_date != null)
				return false;
		} else if (!close_date.equals(other.close_date))
			return false;
		if (cost_id != other.cost_id)
			return false;
		if (create_date == null) {
			if (other.create_date != null)
				return false;
		} else if (!create_date.equals(other.create_date))
			return false;
		if (id != other.id)
			return false;
		if (login_passwd == null) {
			if (other.login_passwd != null)
				return false;
		} else if (!login_passwd.equals(other.login_passwd))
			return false;
		if (os_username == null) {
			if (other.os_username != null)
				return false;
		} else if (!os_username.equals(other.os_username))
			return false;
		if (pause_date == null) {
			if (other.pause_date != null)
				return false;
		} else if (!pause_date.equals(other.pause_date))
			return false;
		if (status == null) {
			if (other.status != null)
				return false;
		} else if (!status.equals(other.status))
			return false;
		if (unix_host == null) {
			if (other.unix_host != null)
				return false;
		} else if (!unix_host.equals(other.unix_host))
			return false;
		return true;
	}
	
}
