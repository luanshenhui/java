package com.f.domain;

/**
 * 
 * @author 冯学明
 *
 * 2015-2-2上午10:15:23
 *   用户类
 */
public class Person extends BaseDomain{
	private String username;
	private String password;
	private String sex;
	private int age;
	private String email;
	private long phone;
	private double salary;
	private Roleaction roleaction;

	public Person(){
		this("","","",0,"",0,0.0);
	}
	
	public Person(String username, String password, String sex, int age,
			String email, long phone, double salary) {
		super();
		this.username = username;
		this.password = password;
		this.sex = sex;
		this.age = age;
		this.email = email;
		this.phone = phone;
		this.salary = salary;
	}
	public Roleaction getRoleaction() {
		return roleaction;
	}
	public void setRoleaction(Roleaction roleaction) {
		this.roleaction = roleaction;
	}
	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public String getSex() {
		return sex;
	}

	public void setSex(String sex) {
		this.sex = sex;
	}

	public long getAge() {
		return age;
	}

	public void setAge(int age) {
		this.age = age;
	}

	public long getPhone() {
		return phone;
	}

	public void setPhone(int phone) {
		this.phone = phone;
	}

	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public double getSalary() {
		return salary;
	}
	public void setSalary(double salary) {
		this.salary = salary;
	}
	
	public void setPhone(long phone) {
		this.phone = phone;
	}

	@Override
	public String toString() {
		return "Person [username=" + username + ", password=" + password
				+ ", sex=" + sex + ", email=" + email + ", age=" + age
				+ ", phone=" + phone + ", salary=" + salary + "]";
	}
}
