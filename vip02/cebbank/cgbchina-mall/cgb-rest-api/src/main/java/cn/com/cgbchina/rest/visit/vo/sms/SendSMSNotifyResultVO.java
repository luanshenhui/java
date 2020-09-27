package cn.com.cgbchina.rest.visit.vo.sms;

import cn.com.cgbchina.rest.visit.vo.BaseResultVo;

import java.io.Serializable;

/**
 * Comment: Created by 11150321050126 on 2016/4/30.
 */
public class SendSMSNotifyResultVO extends BaseResultVo implements Serializable {
	private String serial;
	private String errorCode;
	private String errorMsg;

	public String getErrorCode() {
		return errorCode;
	}

	public void setErrorCode(String errorCode) {
		this.errorCode = errorCode;
	}

	public String getErrorMsg() {
		return errorMsg;
	}

	public void setErrorMsg(String errorMsg) {
		this.errorMsg = errorMsg;
	}

	public String getSerial() {
		return serial;
	}

	public void setSerial(String serial) {
		this.serial = serial;
	}
}
