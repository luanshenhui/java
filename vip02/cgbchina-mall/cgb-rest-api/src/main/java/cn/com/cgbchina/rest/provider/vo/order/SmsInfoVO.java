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
	@NotNull
	@XMLNodeName(value = "TRADECHANNEL")
	private String tradeChannel;
	@NotNull
	@XMLNodeName(value = "TRADESOURCE")
	private String tradeSource;
	@NotNull
	@XMLNodeName(value = "BIZSIGHT")
	private String bizSight;
	@NotNull
	@XMLNodeName(value = "SORCESENDERNO")
	private String sorceSenderNo;
	@NotNull
	@XMLNodeName(value = "OPERATORID")
	private String operatorId;

	public String getTradeSource() {
		return tradeSource;
	}

	public void setTradeSource(String tradeSource) {
		this.tradeSource = tradeSource;
	}

	public String getBizSight() {
		return bizSight;
	}

	public void setBizSight(String bizSight) {
		this.bizSight = bizSight;
	}

	public String getSorceSenderNo() {
		return sorceSenderNo;
	}

	public void setSorceSenderNo(String sorceSenderNo) {
		this.sorceSenderNo = sorceSenderNo;
	}

	public String getOperatorId() {
		return operatorId;
	}

	public void setOperatorId(String operatorId) {
		this.operatorId = operatorId;
	}

	public String getTradeChannel() {
		return tradeChannel;
	}

	public void setTradeChannel(String tradeChannel) {
		this.tradeChannel = tradeChannel;
	}


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
