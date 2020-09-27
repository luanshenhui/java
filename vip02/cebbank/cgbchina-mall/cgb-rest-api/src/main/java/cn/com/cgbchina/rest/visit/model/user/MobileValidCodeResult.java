package cn.com.cgbchina.rest.visit.model.user;

import cn.com.cgbchina.rest.visit.model.BaseResult;

import java.io.Serializable;

/**
 * Comment: Created by 11150321050126 on 2016/4/30.
 */
public class MobileValidCodeResult extends BaseResult implements Serializable {
	private static final long serialVersionUID = 921348812432073830L;
	private String mobileNo;
	private String verifyCode;

	public String getMobileNo() {
		return mobileNo;
	}

	public void setMobileNo(String mobileNo) {
		this.mobileNo = mobileNo;
	}

	public String getVerifyCode() {
		return verifyCode;
	}

	public void setVerifyCode(String verifyCode) {
		this.verifyCode = verifyCode;
	}
}
