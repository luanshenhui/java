package cn.com.cgbchina.rest.visit.vo.order;

import cn.com.cgbchina.rest.common.annotation.XMLNodeName;

public class O2OResultVO {
	@XMLNodeName("result_code")
	private String resultCode;
	@XMLNodeName("result_msg")
	private String resultMsg;

	public String getResultCode() {
		return resultCode;
	}

	public void setResultCode(String resultCode) {
		this.resultCode = resultCode;
	}

	public String getResultMsg() {
		return resultMsg;
	}

	public void setResultMsg(String resultMsg) {
		this.resultMsg = resultMsg;
	}

}
