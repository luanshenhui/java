package cn.com.cgbchina.rest.visit.vo.payment;

import java.io.Serializable;
import java.math.BigDecimal;

import cn.com.cgbchina.rest.common.annotation.XMLNodeName;
import cn.com.cgbchina.rest.visit.vo.BaseQueryVo;

/**
 * Comment: Created by 11150321050126 on 2016/4/29.
 */
public class ReturnPointsInfoVO extends BaseQueryVo implements Serializable {
	private String channelID;
	private String merId;
	private String orderId;
	private String consumeType;
	private String currency;
	@XMLNodeName("trandate")
	private String tranDate;
	@XMLNodeName("trantime")
	private String tranTiem;
	private String tradeSeqNo;
	private String sendDate;
	private String sendTime;
	private String serialNo;
	private String cardNo;
	@XMLNodeName("expirydate")
	private String expiryDate;
	@XMLNodeName("paymomey")
	private BigDecimal payMomey;
	private String jgId;
	private Long decrementAmt;
	private String terminalNo;

	public String getChannelID() {
		return channelID;
	}

	public void setChannelID(String channelID) {
		this.channelID = channelID;
	}

	public String getMerId() {
		return merId;
	}

	public void setMerId(String merId) {
		this.merId = merId;
	}

	public String getOrderId() {
		return orderId;
	}

	public void setOrderId(String orderId) {
		this.orderId = orderId;
	}

	public String getConsumeType() {
		return consumeType;
	}

	public void setConsumeType(String consumeType) {
		this.consumeType = consumeType;
	}

	public String getCurrency() {
		return currency;
	}

	public void setCurrency(String currency) {
		this.currency = currency;
	}

	public String getTradeSeqNo() {
		return tradeSeqNo;
	}

	public void setTradeSeqNo(String tradeSeqNo) {
		this.tradeSeqNo = tradeSeqNo;
	}

	public String getTranDate() {
		return tranDate;
	}

	public void setTranDate(String tranDate) {
		this.tranDate = tranDate;
	}

	public String getTranTiem() {
		return tranTiem;
	}

	public void setTranTiem(String tranTiem) {
		this.tranTiem = tranTiem;
	}

	public String getSendDate() {
		return sendDate;
	}

	public void setSendDate(String sendDate) {
		this.sendDate = sendDate;
	}

	public String getSendTime() {
		return sendTime;
	}

	public void setSendTime(String sendTime) {
		this.sendTime = sendTime;
	}

	public String getSerialNo() {
		return serialNo;
	}

	public void setSerialNo(String serialNo) {
		this.serialNo = serialNo;
	}

	public String getCardNo() {
		return cardNo;
	}

	public void setCardNo(String cardNo) {
		this.cardNo = cardNo;
	}

	public String getExpiryDate() {
		return expiryDate;
	}

	public void setExpiryDate(String expiryDate) {
		this.expiryDate = expiryDate;
	}

	public BigDecimal getPayMomey() {
		return payMomey;
	}

	public void setPayMomey(BigDecimal payMomey) {
		this.payMomey = payMomey;
	}

	public String getJgId() {
		return jgId;
	}

	public void setJgId(String jgId) {
		this.jgId = jgId;
	}

	public Long getDecrementAmt() {
		return decrementAmt;
	}

	public void setDecrementAmt(Long decrementAmt) {
		this.decrementAmt = decrementAmt;
	}

	public String getTerminalNo() {
		return terminalNo;
	}

	public void setTerminalNo(String terminalNo) {
		this.terminalNo = terminalNo;
	}
}
