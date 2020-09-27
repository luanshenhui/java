package cn.com.cgbchina.rest.provider.model.order;

import java.io.Serializable;

import cn.com.cgbchina.rest.provider.model.BaseEntity;

/**
 * MAL121 CC重发验证码 返回对象
 *
 * @author lizy 2016/4/28.
 */
public class CCVerificationCodeReturn extends BaseEntity implements Serializable {
	private static final long serialVersionUID = -8928765735654486444L;
	private String resultCode;

	public String getResultMsg() {
		return resultMsg;
	}

	public void setResultMsg(String resultMsg) {
		this.resultMsg = resultMsg;
	}

	public String getResultCode() {
		return resultCode;
	}

	public void setResultCode(String resultCode) {
		this.resultCode = resultCode;
	}

	private String resultMsg;

}
