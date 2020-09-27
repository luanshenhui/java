package cn.com.cgbchina.rest.provider.model;

import java.io.Serializable;

import cn.com.cgbchina.rest.common.annotation.XMLNodeName;

/**
 * @author lizy 基础实体类
 */

public class BaseEntity implements Serializable {

	private static final long serialVersionUID = -6656217893561980443L;
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
