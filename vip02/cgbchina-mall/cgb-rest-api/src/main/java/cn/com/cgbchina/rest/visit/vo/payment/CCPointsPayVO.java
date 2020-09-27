package cn.com.cgbchina.rest.visit.vo.payment;

import java.io.Serializable;
import java.util.List;

import cn.com.cgbchina.rest.common.annotation.XMLNodeName;
import cn.com.cgbchina.rest.visit.vo.BaseQueryVo;
import lombok.Getter;
import lombok.Setter;

/**
 * Comment: Created by 11150321050126 on 2016/4/29.
 */
@Setter
@Getter
public class CCPointsPayVO extends BaseQueryVo implements Serializable {
	private String tradeSeqNo;
	private String orderId;
	private String accountNo;
	private String amount;
	private String curType;
	private String cvv2;
	private String validDate;
	private String merId;
	private String tradeStatus;
	private String isMerger;
	private String tradeDate;

	private String remark;
	private String channelID;
	private String tradeTime;
	private String tradeCode;
	@XMLNodeName("entry_card")
	private String entryCard;
	private String virtualPrice;
	private String tradeDesc;
	private String fracCardCount;
	@XMLNodeName("terminalNo") // 具体是No还是COde这个联调时测试下
	private String terminalCode;
	private List<CCPointsPayBaseInfoVO> ccPointsPayBaseInfos;
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

	public List<CCPointsPayBaseInfoVO> getCcPointsPayBaseInfos() {
		return ccPointsPayBaseInfos;
	}

	public void setCcPointsPayBaseInfos(List<CCPointsPayBaseInfoVO> ccPointsPayBaseInfos) {
		this.ccPointsPayBaseInfos = ccPointsPayBaseInfos;
	}
}
