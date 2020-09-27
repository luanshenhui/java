package cn.com.cgbchina.rest.visit.vo;

import javax.validation.constraints.NotNull;

/**
 * Comment: Created by 11150321050126 on 2016/4/29.
 */
public class BaseResultVo {
	@NotNull
	private String retCode;
	private String retErrMsg;

	public String getRetCode() {
		return retCode;
	}

	public void setRetCode(String retCode) {
		this.retCode = retCode;
	}

	public String getRetErrMsg() {
		return retErrMsg;
	}

	public void setRetErrMsg(String retErrMsg) {
		this.retErrMsg = retErrMsg;
	}
}
