package cn.com.cgbchina.rest.visit.vo.user;

import java.io.Serializable;

import cn.com.cgbchina.rest.visit.vo.BaseQueryVo;

/**
 * Comment: Created by 11150321050126 on 2016/4/30.
 */
public class RegisterInfoVO extends BaseQueryVo implements Serializable {
	private String logonType;
	private String userPassword;
	private String accPassword;
	private Byte isCreditCard;
	private Byte checkType;
	private Byte passwordType;
	private Byte checkPwdType;
	private Byte checkCertType;
	private String cvv2Code;
	private Byte cvv2CodeFlag;
	private String cardValidPeriod;
	private String pinBlockFlag;
	private Byte validDateFlag;
	private String loginId;
	private String accountNo;
	private String certType;
	private String certNo;
	private String address;
	private String zipCode;
	private String phoneNo;
	private String mobileNo;
	private String email;
	private String backtradeSN;

	private String smsCheckCode;
	private String cardExpiryDateFlag;
	private String clientIP;
	private String clientMacAdress;
	private String clientMainboardNo;
	private String clientHarddiskNo;
	private String transferFlowNo;

	public String getCardExpiryDateFlag() {
		return cardExpiryDateFlag;
	}

	public void setCardExpiryDateFlag(String cardExpiryDateFlag) {
		this.cardExpiryDateFlag = cardExpiryDateFlag;
	}

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

	public Byte getIsCreditCard() {
		return isCreditCard;
	}

	public void setIsCreditCard(Byte isCreditCard) {
		this.isCreditCard = isCreditCard;
	}

	public Byte getCheckType() {
		return checkType;
	}

	public void setCheckType(Byte checkType) {
		this.checkType = checkType;
	}

	public Byte getPasswordType() {
		return passwordType;
	}

	public void setPasswordType(Byte passwordType) {
		this.passwordType = passwordType;
	}

	public Byte getCheckPwdType() {
		return checkPwdType;
	}

	public void setCheckPwdType(Byte checkPwdType) {
		this.checkPwdType = checkPwdType;
	}

	public Byte getCheckCertType() {
		return checkCertType;
	}

	public void setCheckCertType(Byte checkCertType) {
		this.checkCertType = checkCertType;
	}

	public String getCvv2Code() {
		return cvv2Code;
	}

	public void setCvv2Code(String cvv2Code) {
		this.cvv2Code = cvv2Code;
	}

	public Byte getCvv2CodeFlag() {
		return cvv2CodeFlag;
	}

	public void setCvv2CodeFlag(Byte cvv2CodeFlag) {
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

	public Byte getValidDateFlag() {
		return validDateFlag;
	}

	public void setValidDateFlag(Byte validDateFlag) {
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
