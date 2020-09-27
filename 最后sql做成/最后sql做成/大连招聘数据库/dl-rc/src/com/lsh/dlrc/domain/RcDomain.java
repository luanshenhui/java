package com.lsh.dlrc.domain;

public class RcDomain {

	private String tel;
	private String xl;
	private String sch;
	private String name;
	private String sex;
	private String age;
	private String borth;
	private String address;
	private String city;
	private String image;
	private String emil;
	private String workyear;
	private String type;
	private String desireindustry;
	private String filename;
	private String del;

	
	private int beginPage;
	private int endPage;
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

	public String getSch() {
		return sch;
	}

	public void setSch(String sch) {
		this.sch = sch;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getSex() {
		return sex;
	}

	public void setSex(String sex) {
		this.sex = sex;
	}

	public String getAge() {
		return age;
	}

	public void setAge(String age) {
		this.age = age;
	}

	public String getBorth() {
		return borth;
	}

	public void setBorth(String borth) {
		this.borth = borth;
	}

	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}

	public String getCity() {
		return city;
	}

	public void setCity(String city) {
		this.city = city;
	}

	public String getImage() {
		return image;
	}

	public void setImage(String image) {
		this.image = image;
	}

	public String getEmil() {
		return emil;
	}

	public void setEmil(String emil) {
		this.emil = emil;
	}

	public String getWorkyear() {
		return workyear;
	}

	public void setWorkyear(String workyear) {
		this.workyear = workyear;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public String getDesireindustry() {
		return desireindustry;
	}

	public void setDesireindustry(String desireindustry) {
		this.desireindustry = desireindustry;
	}

	public String getFilename() {
		return filename;
	}

	public void setFilename(String filename) {
		this.filename = filename;
	}

	public String getDel() {
		return del;
	}

	public void setDel(String del) {
		this.del = del;
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

	@Override
	public String toString() {
		return "RcDomain [tel=" + tel + ", xl=" + xl + ", sch=" + sch
				+ ", name=" + name + ", sex=" + sex + ", age=" + age
				+ ", borth=" + borth + ", address=" + address + ", city="
				+ city + ", image=" + image + ", emil=" + emil + ", workyear="
				+ workyear + ", type=" + type + ", desireindustry="
				+ desireindustry + ", filename=" + filename + ", del=" + del
				+ ", beginPage=" + beginPage + ", endPage=" + endPage + "]";
	}


}
