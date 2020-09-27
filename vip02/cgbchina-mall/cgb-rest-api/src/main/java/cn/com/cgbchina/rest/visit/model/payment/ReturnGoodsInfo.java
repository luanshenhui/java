package cn.com.cgbchina.rest.visit.model.payment;

import java.io.Serializable;
import java.math.BigDecimal;

import javax.validation.constraints.NotNull;

import cn.com.cgbchina.rest.visit.model.BaseQuery;

/**
 * Comment: Created by 11150321050126 on 2016/4/29.
 */
public class ReturnGoodsInfo extends BaseQuery implements Serializable {

	private static final long serialVersionUID = -6138638429373680967L;
	@NotNull
	private String channel;
	@NotNull
	private String orderId;
	@NotNull
	private String orderTime;
	@NotNull
	private String operTime;
	@NotNull
	private String acrdNo;
	@NotNull
	private BigDecimal tradeMoney;
	@NotNull
	private BigDecimal cashMoney;
	private BigDecimal integralMoney;
	@NotNull
	private String merId;
	@NotNull
	private String qsvendorNo;
	@NotNull
	private String categoryNo;
	@NotNull
	private String orderNbr;
	@NotNull
	private String stagesNum;
	private String operId;
	private BigDecimal discountMoney;
	private String tradeCode;
	private String refundType;//退款类型，01部分退款，不送或空值代表全额退款
	private String payee;//退款接收方标识
	private String tradChannel;//交易渠道 EBS
	private String tradSource;//交易来源 #SC
	private String bizSight;//业务场景 00
	private String sorceSenderNo;//源发起方流水
	private String operatorId;//非金融必填：若为业务操作，填写业务员ID，若为系统自动发起，填SYSTEM

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
