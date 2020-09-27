package cn.com.cgbchina.rest.visit.vo.user;

import cn.com.cgbchina.rest.visit.vo.BaseQueryVo;

import java.io.Serializable;

/**
 * Comment: Created by 11150321050126 on 2016/4/30.
 */
public class ChannelPwdInfoVO extends BaseQueryVo implements Serializable {
	private String mobileNo;
	private String accountNo;
	private String certNo;
	private String certType;
	private String customerName;
	private String checkChannel;
	private String userPassword;
	private String accPassword;
	private String backtradeSN;

	public String getMobileNo() {
		return mobileNo;
	}

	public void setMobileNo(String mobileNo) {
		this.mobileNo = mobileNo;
	}

	public String getAccountNo() {
		return accountNo;
	}

	public void setAccountNo(String accountNo) {
		this.accountNo = accountNo;
	}

	public String getCertNo() {
		return certNo;
	}

	public void setCertNo(String certNo) {
		this.certNo = certNo;
	}

	public String getCertType() {
		return certType;
	}

	public void setCertType(String certType) {
		this.certType = certType;
	}

	public String getCustomerName() {
		return customerName;
	}

	public void setCustomerName(String customerName) {
		this.customerName = customerName;
	}

	public String getCheckChannel() {
		return checkChannel;
	}

	public void setCheckChannel(String checkChannel) {
		this.checkChannel = checkChannel;
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
