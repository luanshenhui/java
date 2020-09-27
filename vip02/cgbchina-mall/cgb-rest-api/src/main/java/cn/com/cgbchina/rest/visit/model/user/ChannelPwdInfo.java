package cn.com.cgbchina.rest.visit.model.user;

import java.io.Serializable;

import javax.validation.constraints.NotNull;

import lombok.Getter;
import lombok.Setter;
import cn.com.cgbchina.rest.visit.model.BaseQuery;

/**
 * Comment: Created by 11150321050126 on 2016/4/30.
 */
@Setter
@Getter
public class ChannelPwdInfo extends BaseQuery implements Serializable {
	private static final long serialVersionUID = -4951916856362813848L;
	private String mobileNo;
	private String accountNo;
	@NotNull
	private String certNo;
	private String certType;
	@NotNull
	private String customerName;
	@NotNull
	private String checkChannel;
	@NotNull
	private String userPassword;
	@NotNull
	private String accPassword;
	private String backtradeSN;
	private String transferFlowNo;

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
