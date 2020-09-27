package cn.com.cgbchina.rest.provider.vo.order;

import java.io.Serializable;

import javax.validation.constraints.NotNull;

import cn.com.cgbchina.rest.common.annotation.XMLNodeName;
import cn.com.cgbchina.rest.provider.vo.BaseEntityVO;

/**
 * MAL121 CC重发验证码 返回对象
 *
 * @author lizy 2016/4/28.
 */
public class CCVerificationCodeReturnVO extends BaseEntityVO implements Serializable {
	private static final long serialVersionUID = -8928765735654486444L;
	@NotNull
	@XMLNodeName(value = "result_code")
	private String resultCode;
	@NotNull
	@XMLNodeName(value = "result_msg")
	private String resultMsg;

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

}
