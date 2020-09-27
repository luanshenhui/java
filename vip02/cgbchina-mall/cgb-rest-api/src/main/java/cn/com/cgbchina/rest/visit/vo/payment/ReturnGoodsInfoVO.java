package cn.com.cgbchina.rest.visit.vo.payment;

import java.io.Serializable;
import java.math.BigDecimal;

import cn.com.cgbchina.rest.visit.vo.BaseQueryVo;

/**
 * Comment: Created by 11150321050126 on 2016/4/29.
 */
public class ReturnGoodsInfoVO extends BaseQueryVo implements Serializable {
	private String channel;
	private String orderId;
	private String orderTime;
	private String operTime;
	private String acrdNo;
	private BigDecimal tradeMoney;
	private BigDecimal cashMoney;
	private BigDecimal integralMoney;
	private String merId;
	private String qsvendorNo;
	private String categoryNo;
	private String orderNbr;
	private String stagesNum;
	private String operId;
	private BigDecimal discountMoney;
	private String tradeCode;
	private String refundType;
	private String payee;
	private String tradChannel;
	private String tradSource;
	private String bizSight;
	private String sorceSenderNo;
	private String operatorId;

	public String getTradChannel() {
		return tradChannel;
	}

	public void setTradChannel(String tradChannel) {
		this.tradChannel = tradChannel;
	}

	public String getTradSource() {
		return tradSource;
	}

	public void setTradSource(String tradSource) {
		this.tradSource = tradSource;
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

	public String getRefundType() {
		return refundType;
	}

	public void setRefundType(String refundType) {
		this.refundType = refundType;
	}

	public String getPayee() {
		return payee;
	}

	public void setPayee(String payee) {
		this.payee = payee;
	}

	public String getChannel() {
		return channel;
	}

	public void setChannel(String channel) {
		this.channel = channel;
	}

	public String getOrderId() {
		return orderId;
	}

	public void setOrderId(String orderId) {
		this.orderId = orderId;
	}

	public String getOrderTime() {
		return orderTime;
	}

	public void setOrderTime(String orderTime) {
		this.orderTime = orderTime;
	}

	public String getOperTime() {
		return operTime;
	}

	public void setOperTime(String operTime) {
		this.operTime = operTime;
	}

	public String getAcrdNo() {
		return acrdNo;
	}

	public void setAcrdNo(String acrdNo) {
		this.acrdNo = acrdNo;
	}

	public BigDecimal getTradeMoney() {
		return tradeMoney;
	}

	public void setTradeMoney(BigDecimal tradeMoney) {
		this.tradeMoney = tradeMoney;
	}

	public BigDecimal getCashMoney() {
		return cashMoney;
	}

	public void setCashMoney(BigDecimal cashMoney) {
		this.cashMoney = cashMoney;
	}

	public BigDecimal getIntegralMoney() {
		return integralMoney;
	}

	public void setIntegralMoney(BigDecimal integralMoney) {
		this.integralMoney = integralMoney;
	}

	public String getMerId() {
		return merId;
	}

	public void setMerId(String merId) {
		this.merId = merId;
	}

	public String getQsvendorNo() {
		return qsvendorNo;
	}

	public void setQsvendorNo(String qsvendorNo) {
		this.qsvendorNo = qsvendorNo;
	}

	public String getCategoryNo() {
		return categoryNo;
	}

	public void setCategoryNo(String categoryNo) {
		this.categoryNo = categoryNo;
	}

	public String getOrderNbr() {
		return orderNbr;
	}

	public void setOrderNbr(String orderNbr) {
		this.orderNbr = orderNbr;
	}

	public String getStagesNum() {
		return stagesNum;
	}

	public void setStagesNum(String stagesNum) {
		this.stagesNum = stagesNum;
	}

	public String getOperId() {
		return operId;
	}

	public void setOperId(String operId) {
		this.operId = operId;
	}

	public BigDecimal getDiscountMoney() {
		return discountMoney;
	}

	public void setDiscountMoney(BigDecimal discountMoney) {
		this.discountMoney = discountMoney;
	}

	public String getTradeCode() {
		return tradeCode;
	}

	public void setTradeCode(String tradeCode) {
		this.tradeCode = tradeCode;
	}
}
