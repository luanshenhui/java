package cn.com.cgbchina.rest.visit.vo.payment;

import java.io.Serializable;

import cn.com.cgbchina.rest.visit.vo.BaseQueryVo;
import lombok.Getter;
import lombok.Setter;

/**
 * Comment: Created by 11150321050126 on 2016/4/29.
 */
@Setter
@Getter
public class ChannelPayInfoVO extends BaseQueryVo implements Serializable {
	private String tradeSeqNo;
	private String merId;
	private String orderId;
	private String accountNo;
	private String certType;
	private String certNo;
	private String curType;
	private String cvv2;
	private String validDate;
	private String isMerger;
	private String channelID;
	private String tradeDate;
	private String tradeTime;
	private String orders;
	private String remark;
	private String terminalCode;

	private String tradeChannel;
	private String tradeSource;
	private String bizSight;
	private String sorceSenderNo;
	private String operatorId;

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
