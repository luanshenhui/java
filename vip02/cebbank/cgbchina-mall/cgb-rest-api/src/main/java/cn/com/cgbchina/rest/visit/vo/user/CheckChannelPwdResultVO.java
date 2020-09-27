package cn.com.cgbchina.rest.visit.vo.user;

import java.io.Serializable;

import cn.com.cgbchina.rest.visit.vo.BaseResultVo;

/**
 * Comment: Created by 11150321050126 on 2016/4/30.
 */
public class CheckChannelPwdResultVO extends BaseResultVo implements Serializable {
	private Byte isCheckPass;
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

	public Byte getIsCheckPass() {
		return isCheckPass;
	}

	public void setIsCheckPass(Byte isCheckPass) {
		this.isCheckPass = isCheckPass;
	}

}
