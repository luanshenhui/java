package cn.com.cgbchina.rest.visit.model.payment;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

import javax.validation.constraints.NotNull;

import cn.com.cgbchina.rest.visit.model.BaseQuery;

/**
 * Comment: Created by 11150321050126 on 2016/4/29.
 */
public class CCPointsPay extends BaseQuery implements Serializable {
	@NotNull
	private String tradeSeqNo;
	@NotNull
	private String orderId;
	@NotNull
	private String accountNo;
	@NotNull
	private String amount;
	@NotNull
	private String curType;
	private String cvv2;
	@NotNull
	private String validDate;
	@NotNull
	private String merId;
	@NotNull
	private String tradeStatus;
	@NotNull
	private Integer isMerger;
	@NotNull
	private Date tradeDate;

	private String remark;
	private String channelID;
	@NotNull
	private String tradeTime;
	private String tradeCode;

	private String entryCard;
	private String virtualPrice;
	private String tradeDesc;
	@NotNull
	private String fracCardCount;
	@NotNull
	private String terminalCode;
	private List<CCPointsPayBaseInfo> ccPointsPayBaseInfos;

	public String getTradeSeqNo() {
		return tradeSeqNo;
	}

	public void setTradeSeqNo(String tradeSeqNo) {
		this.tradeSeqNo = tradeSeqNo;
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

	public String getAmount() {
		return amount;
	}

	public void setAmount(String amount) {
		this.amount = amount;
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

	public String getValidDate() {
		return validDate;
	}

	public void setValidDate(String validDate) {
		this.validDate = validDate;
	}

	public String getMerId() {
		return merId;
	}

	public void setMerId(String merId) {
		this.merId = merId;
	}

	public String getTradeStatus() {
		return tradeStatus;
	}

	public void setTradeStatus(String tradeStatus) {
		this.tradeStatus = tradeStatus;
	}

	public Integer getIsMerger() {
		return isMerger;
	}

	public void setIsMerger(Integer isMerger) {
		this.isMerger = isMerger;
	}

	public Date getTradeDate() {
		return tradeDate;
	}

	public void setTradeDate(Date tradeDate) {
		this.tradeDate = tradeDate;
	}

	public String getRemark() {
		return remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}

	public String getChannelID() {
		return channelID;
	}

	public void setChannelID(String channelID) {
		this.channelID = channelID;
	}

	public String getTradeTime() {
		return tradeTime;
	}

	public void setTradeTime(String tradeTime) {
		this.tradeTime = tradeTime;
	}

	public String getTradeCode() {
		return tradeCode;
	}

	public void setTradeCode(String tradeCode) {
		this.tradeCode = tradeCode;
	}

	public String getEntryCard() {
		return entryCard;
	}

	public void setEntryCard(String entryCard) {
		this.entryCard = entryCard;
	}

	public String getVirtualPrice() {
		return virtualPrice;
	}

	public void setVirtualPrice(String virtualPrice) {
		this.virtualPrice = virtualPrice;
	}

	public String getTradeDesc() {
		return tradeDesc;
	}

	public void setTradeDesc(String tradeDesc) {
		this.tradeDesc = tradeDesc;
	}

	public String getFracCardCount() {
		return fracCardCount;
	}

	public void setFracCardCount(String fracCardCount) {
		this.fracCardCount = fracCardCount;
	}

	public String getTerminalCode() {
		return terminalCode;
	}

	public void setTerminalCode(String terminalCode) {
		this.terminalCode = terminalCode;
	}

	public List<CCPointsPayBaseInfo> getCcPointsPayBaseInfos() {
		return ccPointsPayBaseInfos;
	}

	public void setCcPointsPayBaseInfos(List<CCPointsPayBaseInfo> ccPointsPayBaseInfos) {
		this.ccPointsPayBaseInfos = ccPointsPayBaseInfos;
	}
}
