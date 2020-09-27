package com.cost.account.entity;

import java.sql.Date;

public class Account {
	private int id;
	private int recommender_id;
	private String login_name;
	private String login_passwd;
	private String status;
	private Date create_date;
	private Date pause_date;
	private Date close_date;
	private String real_name;
	private String idcard_no;
	private Date birthdate;
	private String gender;
	private String occupation;
	private String telephone;
	private String email;
	private String mailaddress;
	private String zipcode;
	private String qq;
	private Date last_login_time;
	private String last_login_ip;
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public int getRecommender_id() {
		return recommender_id;
	}
	public void setRecommender_id(int recommenderId) {
		recommender_id = recommenderId;
	}
	public String getLogin_name() {
		return login_name;
	}
	public void setLogin_name(String loginName) {
		login_name = loginName;
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
	public String getReal_name() {
		return real_name;
	}
	public void setReal_name(String realName) {
		real_name = realName;
	}
	public String getIdcard_no() {
		return idcard_no;
	}
	public void setIdcard_no(String idcardNo) {
		idcard_no = idcardNo;
	}
	
	public Date getBirthdate() {
		return birthdate;
	}
	public void setBirthdate(Date birthdate) {
		this.birthdate = birthdate;
	}
	public String getGender() {
		return gender;
	}
	public void setGender(String gender) {
		this.gender = gender;
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
	public Date getLast_login_time() {
		return last_login_time;
	}
	public void setLast_login_time(Date lastLoginTime) {
		last_login_time = lastLoginTime;
	}
	public String getLast_login_ip() {
		return last_login_ip;
	}
	public void setLast_login_ip(String lastLoginIp) {
		last_login_ip = lastLoginIp;
	}
	public Account() {
		super();
		// TODO Auto-generated constructor stub
	}
	public Account(int id, int recommenderId, String loginName,
			String loginPasswd, String status, Date createDate, Date pauseDate,
			Date closeDate, String realName, String idcardNo, Date birthdate,
			String gender, String occupation, String telephone, String email,
			String mailaddress, String zipcode, String qq, Date lastLoginTime,
			String lastLoginIp) {
		super();
		this.id = id;
		recommender_id = recommenderId;
		login_name = loginName;
		login_passwd = loginPasswd;
		this.status = status;
		create_date = createDate;
		pause_date = pauseDate;
		close_date = closeDate;
		real_name = realName;
		idcard_no = idcardNo;
		this.birthdate = birthdate;
		this.gender = gender;
		this.occupation = occupation;
		this.telephone = telephone;
		this.email = email;
		this.mailaddress = mailaddress;
		this.zipcode = zipcode;
		this.qq = qq;
		last_login_time = lastLoginTime;
		last_login_ip = lastLoginIp;
	}
	@Override
	public String toString() {
		return "Account [birthdate=" + birthdate + ", close_date=" + close_date
				+ ", create_date=" + create_date + ", email=" + email
				+ ", gender=" + gender + ", id=" + id + ", idcard_no="
				+ idcard_no + ", last_login_ip=" + last_login_ip
				+ ", last_login_time=" + last_login_time + ", login_name="
				+ login_name + ", login_passwd=" + login_passwd
				+ ", mailaddress=" + mailaddress + ", occupation=" + occupation
				+ ", pause_date=" + pause_date + ", qq=" + qq + ", real_name="
				+ real_name + ", recommender_id=" + recommender_id
				+ ", status=" + status + ", telephone=" + telephone
				+ ", zipcode=" + zipcode + "]";
	}
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result
				+ ((birthdate == null) ? 0 : birthdate.hashCode());
		result = prime * result
				+ ((close_date == null) ? 0 : close_date.hashCode());
		result = prime * result
				+ ((create_date == null) ? 0 : create_date.hashCode());
		result = prime * result + ((email == null) ? 0 : email.hashCode());
		result = prime * result + ((gender == null) ? 0 : gender.hashCode());
		result = prime * result + id;
		result = prime * result
				+ ((idcard_no == null) ? 0 : idcard_no.hashCode());
		result = prime * result
				+ ((last_login_ip == null) ? 0 : last_login_ip.hashCode());
		result = prime * result
				+ ((last_login_time == null) ? 0 : last_login_time.hashCode());
		result = prime * result
				+ ((login_name == null) ? 0 : login_name.hashCode());
		result = prime * result
				+ ((login_passwd == null) ? 0 : login_passwd.hashCode());
		result = prime * result
				+ ((mailaddress == null) ? 0 : mailaddress.hashCode());
		result = prime * result
				+ ((occupation == null) ? 0 : occupation.hashCode());
		result = prime * result
				+ ((pause_date == null) ? 0 : pause_date.hashCode());
		result = prime * result + ((qq == null) ? 0 : qq.hashCode());
		result = prime * result
				+ ((real_name == null) ? 0 : real_name.hashCode());
		result = prime * result + recommender_id;
		result = prime * result + ((status == null) ? 0 : status.hashCode());
		result = prime * result
				+ ((telephone == null) ? 0 : telephone.hashCode());
		result = prime * result + ((zipcode == null) ? 0 : zipcode.hashCode());
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
		Account other = (Account) obj;
		if (birthdate == null) {
			if (other.birthdate != null)
				return false;
		} else if (!birthdate.equals(other.birthdate))
			return false;
		if (close_date == null) {
			if (other.close_date != null)
				return false;
		} else if (!close_date.equals(other.close_date))
			return false;
		if (create_date == null) {
			if (other.create_date != null)
				return false;
		} else if (!create_date.equals(other.create_date))
			return false;
		if (email == null) {
			if (other.email != null)
				return false;
		} else if (!email.equals(other.email))
			return false;
		if (gender == null) {
			if (other.gender != null)
				return false;
		} else if (!gender.equals(other.gender))
			return false;
		if (id != other.id)
			return false;
		if (idcard_no == null) {
			if (other.idcard_no != null)
				return false;
		} else if (!idcard_no.equals(other.idcard_no))
			return false;
		if (last_login_ip == null) {
			if (other.last_login_ip != null)
				return false;
		} else if (!last_login_ip.equals(other.last_login_ip))
			return false;
		if (last_login_time == null) {
			if (other.last_login_time != null)
				return false;
		} else if (!last_login_time.equals(other.last_login_time))
			return false;
		if (login_name == null) {
			if (other.login_name != null)
				return false;
		} else if (!login_name.equals(other.login_name))
			return false;
		if (login_passwd == null) {
			if (other.login_passwd != null)
				return false;
		} else if (!login_passwd.equals(other.login_passwd))
			return false;
		if (mailaddress == null) {
			if (other.mailaddress != null)
				return false;
		} else if (!mailaddress.equals(other.mailaddress))
			return false;
		if (occupation == null) {
			if (other.occupation != null)
				return false;
		} else if (!occupation.equals(other.occupation))
			return false;
		if (pause_date == null) {
			if (other.pause_date != null)
				return false;
		} else if (!pause_date.equals(other.pause_date))
			return false;
		if (qq == null) {
			if (other.qq != null)
				return false;
		} else if (!qq.equals(other.qq))
			return false;
		if (real_name == null) {
			if (other.real_name != null)
				return false;
		} else if (!real_name.equals(other.real_name))
			return false;
		if (recommender_id != other.recommender_id)
			return false;
		if (status == null) {
			if (other.status != null)
				return false;
		} else if (!status.equals(other.status))
			return false;
		if (telephone == null) {
			if (other.telephone != null)
				return false;
		} else if (!telephone.equals(other.telephone))
			return false;
		if (zipcode == null) {
			if (other.zipcode != null)
				return false;
		} else if (!zipcode.equals(other.zipcode))
			return false;
		return true;
	}
	
}
