package cn.com.cgbchina.rest.visit.model.user;

import java.io.Serializable;

import javax.validation.constraints.NotNull;

/**
 * Comment: Created by 11150321050126 on 2016/4/30.
 */
public class LoginInfo implements Serializable {
	private static final long serialVersionUID = 1394763301854740931L;
	@NotNull
	private String loginId;
	@NotNull
	private Byte isCreditCard;
	@NotNull
	private Byte logonType;
	@NotNull
	private String userPassword;
	@NotNull
	private String accPassword;
	private String backtradeSN;
	private String clientIP;
	private String clientMacAddress;
	private String clientMainboardNo;
	private String clientHarddiskNo;

	public String getClientIP() {
		return clientIP;
	}

	public void setClientIP(String clientIP) {
		this.clientIP = clientIP;
	}

	public String getClientMacAddress() {
		return clientMacAddress;
	}

	public void setClientMacAddress(String clientMacAddress) {
		this.clientMacAddress = clientMacAddress;
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

	public String getLoginId() {
		return loginId;
	}

	public void setLoginId(String loginId) {
		this.loginId = loginId;
	}

	public Byte getIsCreditCard() {
		return isCreditCard;
	}

	public void setIsCreditCard(Byte isCreditCard) {
		this.isCreditCard = isCreditCard;
	}

	public Byte getLogonType() {
		return logonType;
	}

	public void setLogonType(Byte logonType) {
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

	public String getBacktradeSN() {
		return backtradeSN;
	}

	public void setBacktradeSN(String backtradeSN) {
		this.backtradeSN = backtradeSN;
	}
}
