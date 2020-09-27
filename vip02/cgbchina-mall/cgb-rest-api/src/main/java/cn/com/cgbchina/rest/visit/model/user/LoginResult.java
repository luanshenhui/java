package cn.com.cgbchina.rest.visit.model.user;

import java.io.Serializable;
import java.util.List;

import javax.validation.constraints.Pattern;

import cn.com.cgbchina.rest.visit.model.BaseResult;

/**
 * Comment: Created by 11150321050126 on 2016/4/30.
 */
public class LoginResult extends BaseResult implements Serializable {
	private String customerId;
	private String customerName;
	private String customerSex;
	private String certType;
	private String certNo;
	private String address;
	private String zipCode;
	private String phoneNo;
	@Pattern(regexp = "^[1][3,4,5,8][0-9]{9}$")
	private String mobileNo;
	private String email;
	private String isCheckPassword;
	private String checkChannelState;
	private List<LoginCardInfo> loginCardInfos;
	private String hostReturnCode;// hostReturnCode
	private String hostErrorMessage;// ��Ӧ��Ϣ

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

	public String getIsCheckPassword() {
		return isCheckPassword;
	}

	public void setIsCheckPassword(String isCheckPassword) {
		this.isCheckPassword = isCheckPassword;
	}

	public String getCheckChannelState() {
		return checkChannelState;
	}

	public void setCheckChannelState(String checkChannelState) {
		this.checkChannelState = checkChannelState;
	}

	public List<LoginCardInfo> getLoginCardInfos() {
		return loginCardInfos;
	}

	public void setLoginCardInfos(List<LoginCardInfo> loginCardInfos) {
		this.loginCardInfos = loginCardInfos;
	}
}
