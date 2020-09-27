package cn.com.cgbchina.rest.visit.vo.user;

import java.io.Serializable;

import javax.validation.constraints.NotNull;

import cn.com.cgbchina.rest.common.annotation.XMLNodeName;
import cn.com.cgbchina.rest.visit.vo.BaseResultVo;

/**
 * Comment: Created by 11150321050126 on 2016/4/30.
 */
public class MobileValidCodeResultVO extends BaseResultVo implements Serializable {
	@NotNull
	@XMLNodeName("MOBILE")
	private String mobileNo;
	private String verifyCode;
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
