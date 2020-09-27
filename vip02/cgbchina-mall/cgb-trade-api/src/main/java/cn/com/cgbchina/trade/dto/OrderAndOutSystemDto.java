/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.trade.dto;

import java.io.Serializable;

import cn.com.cgbchina.trade.model.OrderSubModel;

/**
 * @author niufw
 * @version 1.0
 * @Since 2016/8/17.
 */
public class OrderAndOutSystemDto extends OrderSubModel implements Serializable {

	private static final long serialVersionUID = 5999275435932524864L;
	private String verifyCode;//验证码

	public String getVerifyCode() {
		return verifyCode;
	}

	public void setVerifyCode(String verifyCode) {
		this.verifyCode = verifyCode;
	}

	private String validateStatus;//验证码状态

	public String getValidateStatus() {
		return validateStatus;
	}

	public void setValidateStatus(String validateStatus) {
		this.validateStatus = validateStatus;
	}
}