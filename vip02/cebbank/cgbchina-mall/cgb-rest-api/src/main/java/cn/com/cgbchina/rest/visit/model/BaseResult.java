package cn.com.cgbchina.rest.visit.model;

import javax.validation.constraints.NotNull;
import java.io.Serializable;

/**
 * Comment: Created by 11150321050126 on 2016/4/29.
 */
public class BaseResult implements Serializable {
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
