package cn.com.cgbchina.rest.visit.vo.user;

import java.io.Serializable;

import javax.validation.constraints.NotNull;

import cn.com.cgbchina.rest.visit.vo.BaseResultVo;

/**
 * Comment: Created by 11150321050126 on 2016/4/30.
 */
public class UserInfoVO extends BaseResultVo implements Serializable {
	@NotNull
	private String customerId;
	@NotNull
	private String customerName;
	@NotNull
	private String customerSex;
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
	@NotNull
	private String transferFlowNo;
	private String hostReturnCode;
	private String hostErrorMessage;

	public String getHostReturnCode() {
		return hostReturnCode;
	}

	public void setHostReturnCode(String hostReturnCode) {
		this.hostReturnCode = hostReturnCode;
	}

	public String getHostErrorMessage() {
		return hostErrorMessage;
	}

	public void setHostErrorMessage(String hostErrorMessage) {
		this.hostErrorMessage = hostErrorMessage;
	}

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

	public String getCustomerSex() {
		return customerSex;
	}

	public void setCustomerSex(String customerSex) {
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

	public String getTransferFlowNo() {
		return transferFlowNo;
	}

	public void setTransferFlowNo(String transferFlowNo) {
		this.transferFlowNo = transferFlowNo;
	}
}
