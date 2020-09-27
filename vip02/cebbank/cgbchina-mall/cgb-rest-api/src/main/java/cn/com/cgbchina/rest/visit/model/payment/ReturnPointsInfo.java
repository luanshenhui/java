package cn.com.cgbchina.rest.visit.model.payment;

import cn.com.cgbchina.rest.visit.model.BaseQuery;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;

import javax.validation.constraints.NotNull;

/**
 * Comment: Created by 11150321050126 on 2016/4/29.
 */
public class ReturnPointsInfo extends BaseQuery implements Serializable {
	private static final long serialVersionUID = -3982107933157286814L;
	@NotNull
	private String channelID;
	@NotNull
	private String merId;
	@NotNull
	private String orderId;
	@NotNull
	private String consumeType;
	@NotNull
	private String currency;
	@NotNull
	private String tranDate;
	@NotNull
	private String tranTiem;
	@NotNull
	private String tradeSeqNo;
	@NotNull
	private String sendDate;
	@NotNull
	private String sendTime;
	@NotNull
	private String serialNo;
	@NotNull
	private String cardNo;
	@NotNull
	private String expiryDate;
	@NotNull
	private BigDecimal payMomey;
	@NotNull
	private String jgId;
	@NotNull
	private Long decrementAmt;
	@NotNull
	private String terminalNo;

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
