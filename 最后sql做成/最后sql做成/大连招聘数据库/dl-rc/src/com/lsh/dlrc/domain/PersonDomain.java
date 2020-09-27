package com.lsh.dlrc.domain;

public class PersonDomain {
	String tel;
	String education;
	String sch;
	String name;
	String sex;
	String age;
	String borth;
	String address;
	String city;
	String image;
	String emil;
	String workyear;
	String type;
	String desireindustry;
	String expect;

	public String getTel() {
		return tel;
	}

	public void setTel(String tel) {
		this.tel = tel;
	}

	public String getEducation() {
		return education;
	}

	public void setEducation(String education) {
		this.education = education;
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

	public String getExpect() {
		return expect;
	}

	public void setExpect(String expect) {
		this.expect = expect;
	}

	@Override
	public String toString() {
		return "PersonDomain [tel=" + tel + ", education=" + education + ", sch=" + sch + ", name=" + name + ", sex="
				+ sex + ", age=" + age + ", borth=" + borth + ", address=" + address + ", city=" + city + ", image="
				+ image + ", emil=" + emil + ", workyear=" + workyear + ", type=" + type + ", desireindustry="
				+ desireindustry + ", expect=" + expect + "]";
	}

}
