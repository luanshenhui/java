package cn.com.cgbchina.rest.provider.vo.payment;

import java.io.Serializable;

import cn.com.cgbchina.rest.provider.vo.BaseEntityVO;

/**
 * MAL503 微信发起支付接口
 * 
 * @author lizy 2016/4/28.
 */
public class WXPayVO extends BaseEntityVO implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = -7595058046025045084L;
	private String tradeChannel;
	private String tradeSource;
	private String bizSight;
	private String sorceSenderNo;
	private String operatorId;
	private String channelSN;
	private String orderMainId;
	private String cardNo;
	private String validDate;
	private String ordermainDesc;
	private String isMoney;
	private String isMerge;

	public String getTradeChannel() {
		return tradeChannel;
	}

	public void setTradeChannel(String tradeChannel) {
		this.tradeChannel = tradeChannel;
	}

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

	public String getChannelSN() {
		return channelSN;
	}

	public void setChannelSN(String channelSN) {
		this.channelSN = channelSN;
	}

	public String getOrderMainId() {
		return orderMainId;
	}

	public void setOrderMainId(String orderMainId) {
		this.orderMainId = orderMainId;
	}

	public String getCardNo() {
		return cardNo;
	}

	public void setCardNo(String cardNo) {
		this.cardNo = cardNo;
	}

	public String getValidDate() {
		return validDate;
	}

	public void setValidDate(String validDate) {
		this.validDate = validDate;
	}

	public String getOrdermainDesc() {
		return ordermainDesc;
	}

	public void setOrdermainDesc(String ordermainDesc) {
		this.ordermainDesc = ordermainDesc;
	}

	public String getIsMoney() {
		return isMoney;
	}

	public void setIsMoney(String isMoney) {
		this.isMoney = isMoney;
	}

	public String getIsMerge() {
		return isMerge;
	}

	public void setIsMerge(String isMerge) {
		this.isMerge = isMerge;
	}

}
