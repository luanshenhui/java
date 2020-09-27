package cn.com.cgbchina.rest.visit.model.payment;

import java.io.Serializable;

import javax.validation.constraints.NotNull;

import cn.com.cgbchina.rest.visit.model.BaseQuery;
import lombok.Getter;
import lombok.Setter;

/**
 * Comment: Created by 11150321050126 on 2016/4/29.
 */
@Setter
@Getter
public class ChannelPayInfo extends BaseQuery implements Serializable {
	private static final long serialVersionUID = -420197715428313762L;
	@NotNull
	private String tradeSeqNo;
	@NotNull
	private String merId;
	@NotNull
	private String orderId;
	@NotNull
	private String accountNo;
	private String certType;
	@NotNull
	private String certNo;
	@NotNull
	private String curType;
	private String cvv2;
	@NotNull
	private String validDate;
	@NotNull
	private String isMerger;
	@NotNull
	private String channelID;
	@NotNull
	private String tradeDate;
	@NotNull
	private String tradeTime;
	@NotNull
	private String orders;
	private String remark;
	@NotNull
	private String terminalCode;

	private String tradeChannel;
	private String tradeSource;
	private String bizSight;
	private String sorceSenderNo;
	private String operatorId;

	public String getValidDate() {
		return validDate;
	}

	public void setValidDate(String validDate) {
		this.validDate = validDate;
	}

	public String getTradeDate() {
		return tradeDate;
	}

	public void setTradeDate(String tradeDate) {
		this.tradeDate = tradeDate;
	}

	public String getTradeTime() {
		return tradeTime;
	}

	public void setTradeTime(String tradeTime) {
		this.tradeTime = tradeTime;
	}

	public String getTradeSeqNo() {
		return tradeSeqNo;
	}

	public void setTradeSeqNo(String tradeSeqNo) {
		this.tradeSeqNo = tradeSeqNo;
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

	public String getAccountNo() {
		return accountNo;
	}

	public void setAccountNo(String accountNo) {
		this.accountNo = accountNo;
	}

	public String getCertType() {
		return certType;
	}

	public void setCertType(String certType) {
		this.certType = certType;
	}

	public String getCertNo() {
		return certNo;
	}

	public void setCertNo(String certNo) {
		this.certNo = certNo;
	}

	public String getCurType() {
		return curType;
	}

	public void setCurType(String curType) {
		this.curType = curType;
	}

	public String getCvv2() {
		return cvv2;
	}

	public void setCvv2(String cvv2) {
		this.cvv2 = cvv2;
	}

	public String getIsMerger() {
		return isMerger;
	}

	public void setIsMerger(String isMerger) {
		this.isMerger = isMerger;
	}

	public String getChannelID() {
		return channelID;
	}

	public void setChannelID(String channelID) {
		this.channelID = channelID;
	}

	public String getOrders() {
		return orders;
	}

	public void setOrders(String orders) {
		this.orders = orders;
	}

	public String getRemark() {
		return remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}

	public String getTerminalCode() {
		return terminalCode;
	}

	public void setTerminalCode(String terminalCode) {
		this.terminalCode = terminalCode;
	}
}
