package com.cost.entity;

import java.util.Date;

public class Cost_Admin {
	/*CREATE TABLE ADMIN_INFO(
   ID NUMBER(11) PRIMARY KEY NOT NULL,
   ADMIN_CODE varchar2(30) UNIQUE NOT NULL,
   PASSWORD varchar2(8) NOT NULL,
   NAME varchar2(20) NOT NULL,
   TELEPHONE varchar2(15),
   EMAIL varchar2(50),
   ENROLLDATE date NOT NULL
);
	 * */
	private int id;
	private String admin_code;
	private String password;
	private String name;
	private String telephone;
	private String email;
	private Date enrolldate;
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getAdmin_code() {
		return admin_code;
	}
	public void setAdmin_code(String adminCode) {
		admin_code = adminCode;
	}
	public String getPassword() {
		return password;
	}
	public void setPassword(String password) {
		this.password = password;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
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
	public Date getEnrolldate() {
		return enrolldate;
	}
	public void setEnrolldate(Date enrolldate) {
		this.enrolldate = enrolldate;
	}
	public Cost_Admin(int id, String adminCode, String password, String name,
			String telephone, String email, Date enrolldate) {
		super();
		this.id = id;
		admin_code = adminCode;
		this.password = password;
		this.name = name;
		this.telephone = telephone;
		this.email = email;
		this.enrolldate = enrolldate;
	}
	public Cost_Admin() {
		super();
		// TODO Auto-generated constructor stub
	}
	@Override
	public String toString() {
		return "Cost_Admin [admin_code=" + admin_code + ", email=" + email
				+ ", enrolldate=" + enrolldate + ", id=" + id + ", name="
				+ name + ", password=" + password + ", telephone=" + telephone
				+ "]";
	}
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result
				+ ((admin_code == null) ? 0 : admin_code.hashCode());
		result = prime * result + ((email == null) ? 0 : email.hashCode());
		result = prime * result
				+ ((enrolldate == null) ? 0 : enrolldate.hashCode());
		result = prime * result + id;
		result = prime * result + ((name == null) ? 0 : name.hashCode());
		result = prime * result
				+ ((password == null) ? 0 : password.hashCode());
		result = prime * result
				+ ((telephone == null) ? 0 : telephone.hashCode());
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
		Cost_Admin other = (Cost_Admin) obj;
		if (admin_code == null) {
			if (other.admin_code != null)
				return false;
		} else if (!admin_code.equals(other.admin_code))
			return false;
		if (email == null) {
			if (other.email != null)
				return false;
		} else if (!email.equals(other.email))
			return false;
		if (enrolldate == null) {
			if (other.enrolldate != null)
				return false;
		} else if (!enrolldate.equals(other.enrolldate))
			return false;
		if (id != other.id)
			return false;
		if (name == null) {
			if (other.name != null)
				return false;
		} else if (!name.equals(other.name))
			return false;
		if (password == null) {
			if (other.password != null)
				return false;
		} else if (!password.equals(other.password))
			return false;
		if (telephone == null) {
			if (other.telephone != null)
				return false;
		} else if (!telephone.equals(other.telephone))
			return false;
		return true;
	}
	
}
