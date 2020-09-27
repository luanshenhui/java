package cn.com.cgbchina.rest.visit.model.user;

import cn.com.cgbchina.rest.visit.model.BaseResult;

import java.io.Serializable;
import java.util.List;

import javax.validation.constraints.NotNull;

/**
 * Comment: Created by 11150321050126 on 2016/4/30.
 */
public class RegisterResult extends BaseResult implements Serializable {
	private static final long serialVersionUID = 5642693811607187744L;
	@NotNull
	private String customerId;
	@NotNull
	private String customerName;
	@NotNull
	private Byte customerSex;
	@NotNull
	private String certType;
	@NotNull
	private String certNo;
	@NotNull
	private String address;
	@NotNull
	private String zipCode;
	@NotNull
	private String phoneNo;
	@NotNull
	private String mobileNo;
	@NotNull
	private String email;
	private List<LoginCardInfo> loginCardInfos;

	public String getCustomerId() {
		return customerId;
	}

	public void setCustomerId(String customerId) {
		this.customerId = customerId;
	}

	public String getCustomerName() {
		return customerName;
	}

	public void setCustomerName(String customerName) {
		this.customerName = customerName;
	}

	public Byte getCustomerSex() {
		return customerSex;
	}

	public void setCustomerSex(Byte customerSex) {
		this.customerSex = customerSex;
	}

	public String getCertType() {
		return certType;
	}

	public void setCertType(String certType) {
		this.certType = certType;
	}

	public String getCertNo() {
		return certNo;
	}

	public void setCertNo(String certNo) {
		this.certNo = certNo;
	}

	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}

	public String getZipCode() {
		return zipCode;
	}

	public void setZipCode(String zipCode) {
		this.zipCode = zipCode;
	}

	public String getPhoneNo() {
		return phoneNo;
	}

	public void setPhoneNo(String phoneNo) {
		this.phoneNo = phoneNo;
	}

	public String getMobileNo() {
		return mobileNo;
	}

	public void setMobileNo(String mobileNo) {
		this.mobileNo = mobileNo;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public List<LoginCardInfo> getLoginCardInfos() {
		return loginCardInfos;
	}

	public void setLoginCardInfos(List<LoginCardInfo> loginCardInfos) {
		this.loginCardInfos = loginCardInfos;
	}
}
