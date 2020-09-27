package cn.com.cgbchina.rest.provider.model.order;

import cn.com.cgbchina.rest.provider.model.BaseQueryEntity;

/**
 * 短彩信回执接口
 * 
 * @author Lizy
 *
 */
public class MsgQuery extends BaseQueryEntity {

	/**
	 * 
	 */
	private static final long serialVersionUID = -1602557950469102438L;
	private String orderNo;
	private String suborderNo;
	private String msgType;
	private String mobile;
	private String status;
	private String statusMsg;

	public String getOrderNo() {
		return orderNo;
	}

	public void setOrderNo(String orderNo) {
		this.orderNo = orderNo;
	}

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
