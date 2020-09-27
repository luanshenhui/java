package cn.com.cgbchina.rest.visit.vo.user;

import java.io.Serializable;

import cn.com.cgbchina.rest.common.annotation.XMLNodeName;
import cn.com.cgbchina.rest.visit.vo.BaseResultVo;

import java.io.Serializable;

/**
 * Comment: Created by 11150321050126 on 2016/4/30.
 */
public class LoginInfoVO extends BaseResultVo implements Serializable {
	private String loginId;
	private String isCreditCard;
	private String logonType;
	private String userPassword;
	private String accPassword;
	private String backtradeSN;
	private String clientIP;
	@XMLNodeName("clientMacAdress")
	private String clientMacAddress;
	private String clientMainboardNo;
	private String clientHarddiskNo;
	private String transferFlowNo;

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

	public String getTransferFlowNo() {
		return transferFlowNo;
	}

	public void setTransferFlowNo(String transferFlowNo) {
		this.transferFlowNo = transferFlowNo;
	}

	public String getLoginId() {
		return loginId;
	}

	public void setLoginId(String loginId) {
		this.loginId = loginId;
	}

	public String getIsCreditCard() {
		return isCreditCard;
	}

	public void setIsCreditCard(String isCreditCard) {
		this.isCreditCard = isCreditCard;
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

	public String getBacktradeSN() {
		return backtradeSN;
	}

	public void setBacktradeSN(String backtradeSN) {
		this.backtradeSN = backtradeSN;
	}
}
