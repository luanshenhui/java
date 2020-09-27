package cn.com.cgbchina.rest.visit.vo.user;

import cn.com.cgbchina.rest.visit.vo.BaseResultVo;

import java.io.Serializable;

/**
 * Comment: Created by 11150321050126 on 2016/4/30.
 */
public class LoginInfoVO extends BaseResultVo implements Serializable {
	private String loginId;
	private String isCreditCard;
	private Byte logonType;
	private String userPassword;
	private String accPassword;
	private String backtradeSN;

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
