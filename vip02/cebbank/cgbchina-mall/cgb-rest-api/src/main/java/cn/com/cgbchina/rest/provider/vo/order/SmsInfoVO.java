package cn.com.cgbchina.rest.provider.vo.order;

import javax.validation.constraints.NotNull;

import cn.com.cgbchina.rest.common.annotation.XMLNodeName;
import cn.com.cgbchina.rest.provider.vo.BaseQueryEntityVO;

/**
 * DXZF01 上行短信内容实时转发
 * 
 * @author Lizy
 * 
 */
public class SmsInfoVO extends BaseQueryEntityVO {

	/**
	 * 
	 */
	private static final long serialVersionUID = -8794212564950711215L;
	@NotNull
	@XMLNodeName(value = "MOBILE")
	private String mobile;
	@NotNull
	@XMLNodeName(value = "SERIAL")
	private String serial;
	@NotNull
	@XMLNodeName(value = "MSGCONTENT")
	private String msgContent;

	public String getMobile() {
		return mobile;
	}

	public void setMobile(String mobile) {
		this.mobile = mobile;
	}

	public String getSerial() {
		return serial;
	}

	public void setSerial(String serial) {
		this.serial = serial;
	}

	public String getMsgContent() {
		return msgContent;
	}

	public void setMsgContent(String msgContent) {
		this.msgContent = msgContent;
	}

}
