package cn.com.cgbchina.rest.provider.vo.order;

import javax.validation.constraints.NotNull;

import cn.com.cgbchina.rest.common.annotation.XMLNodeName;
import cn.com.cgbchina.rest.provider.vo.BaseQueryEntityVO;

/**
 * 短彩信回执接口 对应xml报文生成的对象
 * 
 * @author Lizy
 *
 */
public class MsgQueryOrderVO extends BaseQueryEntityVO {

	private static final long serialVersionUID = -6666502407193359950L;

	@NotNull
	@XMLNodeName(value = "suborderno")
	private String suborderNo;

	@NotNull
	@XMLNodeName(value = "msgtype")
	private String msgType;

	@XMLNodeName(value = "mobile")
	private String mobile;

	@XMLNodeName(value = "status")
	private String status;

	@XMLNodeName(value = "statusmsg")
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
