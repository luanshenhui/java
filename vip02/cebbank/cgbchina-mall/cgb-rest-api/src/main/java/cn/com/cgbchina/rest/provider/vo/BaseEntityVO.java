package cn.com.cgbchina.rest.provider.vo;

import java.io.Serializable;

import javax.validation.constraints.NotNull;

import cn.com.cgbchina.rest.common.annotation.XMLNodeName;

public class BaseEntityVO implements Serializable {
	/**
	 * 
	 */
	private static final long serialVersionUID = 6863084724481311532L;
	@NotNull
	private String returnCode;
	private String returnDes;
	@XMLNodeName(value = "ERRORMSG")
	private String errormsg;
	private String successCode;

	public String getSuccessCode() {
		return successCode;
	}

	public void setSuccessCode(String successCode) {
		this.successCode = successCode;
	}

	public String getErrormsg() {
		return errormsg;
	}

	public void setErrormsg(String errormsg) {
		this.errormsg = errormsg;
	}

	public String getReturnCode() {
		return returnCode;
	}

	public void setReturnCode(String returnCode) {
		this.returnCode = returnCode;
	}

	public String getReturnDes() {
		return returnDes;
	}

	public void setReturnDes(String returnDes) {
		this.returnDes = returnDes;
	}

}
