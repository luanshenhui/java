package com.lsh.chinarc.domain;

public class User {
	
	private long id;
	private String name;
	private String tel;
	private String xl;
	private String midetel;
	private String borth;
	private String age;
	private String personName;
	private String hukou;
	private String city;
	private String zt;
	private int beginPage;
	private int endPage;
	public long getId() {
		return id;
	}
	public void setId(long id) {
		this.id = id;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	
	public String getTel() {
		return tel;
	}
	public void setTel(String tel) {
		this.tel = tel;
	}
	public String getXl() {
		return xl;
	}
	public void setXl(String xl) {
		this.xl = xl;
	}
	public String getMidetel() {
		return midetel;
	}
	public void setMidetel(String midetel) {
		this.midetel = midetel;
	}
	public String getBorth() {
		return borth;
	}
	public void setBorth(String borth) {
		this.borth = borth;
	}
	public String getAge() {
		return age;
	}
	public void setAge(String age) {
		this.age = age;
	}
	
	public String getPersonName() {
		return personName;
	}
	public void setPersonName(String personName) {
		this.personName = personName;
	}
	public String getHukou() {
		return hukou;
	}
	public void setHukou(String hukou) {
		this.hukou = hukou;
	}
	public String getCity() {
		return city;
	}
	public void setCity(String city) {
		this.city = city;
	}
	
	
	public int getBeginPage() {
		return beginPage;
	}
	public void setBeginPage(int beginPage) {
		this.beginPage = beginPage;
	}
	public int getEndPage() {
		return endPage;
	}
	public void setEndPage(int endPage) {
		this.endPage = endPage;
	}
	
	public String getZt() {
		return zt;
	}
	public void setZt(String zt) {
		this.zt = zt;
	}
	@Override
	public String toString() {
		return "User [id=" + id + ", name=" + name + ", tel=" + tel + ", xl="
				+ xl + ", midetel=" + midetel + ", borth=" + borth + ", age="
				+ age + ", personName=" + personName + ", hukou=" + hukou
				+ ", city=" + city + "]";
	}
	
	
	
}
