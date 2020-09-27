package cn.com.cgbchina.rest.provider.model.order;

import cn.com.cgbchina.rest.provider.model.BaseQueryEntity;

/**
 * DXZF01 上行短信内容实时转发
 * 
 * @author Lizy
 *
 */
public class SmsInfo extends BaseQueryEntity {

	/**
	 * 
	 */
	private static final long serialVersionUID = -8794212564950711215L;
	private String mobile;
	private String serial;
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
