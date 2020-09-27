package cn.com.cgbchina.rest.visit.model.user;

import java.io.Serializable;

import javax.validation.constraints.NotNull;

import cn.com.cgbchina.rest.visit.model.BaseQuery;

/**
 * Comment: Created by 11150321050126 on 2016/4/30.
 */
public class RegisterInfo extends BaseQuery implements Serializable {
	@NotNull
	private String logonType;
	@NotNull
	private String userPassword;
	@NotNull
	private String accPassword;
	@NotNull
	private String isCreditCard;
	private String checkType;
	private String passwordType;
	private String checkPwdType;
	private String checkCertType;
	private String cvv2Code;
	private String cvv2CodeFlag;
	private String cardValidPeriod;
	private String pinBlockFlag;
	private String validDateFlag;
	private String loginId;
	@NotNull
	private String accountNo;
	@NotNull
	private String certType;
	@NotNull
	private String certNo;
	private String address;
	private String zipCode;
	private String phoneNo;
	private String mobileNo;
	@NotNull
	private String email;
	private String backtradeSN;

	private String smsCheckCode;
	private String clientIP;
	private String clientMacAdress;
	private String clientMainboardNo;
	private String clientHarddiskNo;
	private String transferFlowNo;

	public String getSmsCheckCode() {
		return smsCheckCode;
	}

	public void setSmsCheckCode(String smsCheckCode) {
		this.smsCheckCode = smsCheckCode;
	}

	public String getClientIP() {
		return clientIP;
	}

	public void setClientIP(String clientIP) {
		this.clientIP = clientIP;
	}

	public String getClientMacAdress() {
		return clientMacAdress;
	}

	public void setClientMacAdress(String clientMacAdress) {
		this.clientMacAdress = clientMacAdress;
	}

	public String getClientMainboardNo() {
		return clientMainboardNo;
	}

	public void setClientMainboardNo(String clientMainboardNo) {
		this.clientMainboardNo = clientMainboardNo;
	}

	public String getClientHarddiskNo() {
		return clientHarddiskNo;
	}

	public void setClientHarddiskNo(String clientHarddiskNo) {
		this.clientHarddiskNo = clientHarddiskNo;
	}

	public String getTransferFlowNo() {
		return transferFlowNo;
	}

	public void setTransferFlowNo(String transferFlowNo) {
		this.transferFlowNo = transferFlowNo;
	}

	public String getLogonType() {
		return logonType;
	}

	public void setLogonType(String logonType) {
		this.logonType = logonType;
	}

	public String getUserPassword() {
		return userPassword;
	}

	public void setUserPassword(String userPassword) {
		this.userPassword = userPassword;
	}

	public String getAccPassword() {
		return accPassword;
	}

	public void setAccPassword(String accPassword) {
		this.accPassword = accPassword;
	}

	public String getCvv2Code() {
		return cvv2Code;
	}

	public void setCvv2Code(String cvv2Code) {
		this.cvv2Code = cvv2Code;
	}

	public String getIsCreditCard() {
		return isCreditCard;
	}

	public void setIsCreditCard(String isCreditCard) {
		this.isCreditCard = isCreditCard;
	}

	public String getCheckType() {
		return checkType;
	}

	public void setCheckType(String checkType) {
		this.checkType = checkType;
	}

	public String getPasswordType() {
		return passwordType;
	}

	public void setPasswordType(String passwordType) {
		this.passwordType = passwordType;
	}

	public String getCheckPwdType() {
		return checkPwdType;
	}

	public void setCheckPwdType(String checkPwdType) {
		this.checkPwdType = checkPwdType;
	}

	public String getCheckCertType() {
		return checkCertType;
	}

	public void setCheckCertType(String checkCertType) {
		this.checkCertType = checkCertType;
	}

	public String getCvv2CodeFlag() {
		return cvv2CodeFlag;
	}

	public void setCvv2CodeFlag(String cvv2CodeFlag) {
		this.cvv2CodeFlag = cvv2CodeFlag;
	}

	public String getCardValidPeriod() {
		return cardValidPeriod;
	}

	public void setCardValidPeriod(String cardValidPeriod) {
		this.cardValidPeriod = cardValidPeriod;
	}

	public String getPinBlockFlag() {
		return pinBlockFlag;
	}

	public void setPinBlockFlag(String pinBlockFlag) {
		this.pinBlockFlag = pinBlockFlag;
	}

	public String getValidDateFlag() {
		return validDateFlag;
	}

	public void setValidDateFlag(String validDateFlag) {
		this.validDateFlag = validDateFlag;
	}

	public String getLoginId() {
		return loginId;
	}

	public void setLoginId(String loginId) {
		this.loginId = loginId;
	}

	public String getAccountNo() {
		return accountNo;
	}

	public void setAccountNo(String accountNo) {
		this.accountNo = accountNo;
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

	public String getBacktradeSN() {
		return backtradeSN;
	}

	public void setBacktradeSN(String backtradeSN) {
		this.backtradeSN = backtradeSN;
	}
}
