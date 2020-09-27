package cn.com.cgbchina.rest.provider.model.order;

import cn.com.cgbchina.rest.provider.model.BaseQueryEntity;

import java.io.Serializable;

/**
 * 发码（购票）成功通知接口
 * 
 * @author lizy
 *
 */
public class MsgReceiptOrderInfo extends BaseQueryEntity implements Serializable {


	/**
	 * 
	 */
	private static final long serialVersionUID = 858470024945002442L;
	private String suborderNo;
	private String msgType;
	private String mobile;
	private String status;
	private String statusMsg;

	public String getSuborderNo() {
		return suborderNo;
	}

	public void setSuborderNo(String suborderNo) {
		this.suborderNo = suborderNo;
	}

	public String getMsgType() {
		return msgType;
	}

	public void setMsgType(String msgType) {
		this.msgType = msgType;
	}

	public String getMobile() {
		return mobile;
	}

	public void setMobile(String mobile) {
		this.mobile = mobile;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getStatusMsg() {
		return statusMsg;
	}

	public void setStatusMsg(String statusMsg) {
		this.statusMsg = statusMsg;
	}
}
