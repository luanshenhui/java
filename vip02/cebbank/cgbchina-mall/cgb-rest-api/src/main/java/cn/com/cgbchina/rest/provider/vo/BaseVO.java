package cn.com.cgbchina.rest.provider.vo;

import java.io.Serializable;

public class BaseVO implements Serializable {
	/**
	 * 
	 */
	private static final long serialVersionUID = 6863084724481311532L;
	private String returnCode;
	private String returnDes;

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
