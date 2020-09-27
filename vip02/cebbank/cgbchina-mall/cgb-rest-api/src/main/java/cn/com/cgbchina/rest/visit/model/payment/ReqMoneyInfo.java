package cn.com.cgbchina.rest.visit.model.payment;

import cn.com.cgbchina.rest.visit.model.BaseQuery;

import java.io.Serializable;
import java.math.BigDecimal;

import javax.validation.constraints.NotNull;

/**
 * Comment: Created by 11150321050126 on 2016/4/29.
 */
public class ReqMoneyInfo extends BaseQuery implements Serializable {
	private static final long serialVersionUID = -268444530269792114L;
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
	private BigDecimal discountMoney;
	private String tradeCode;
	private String balancePayer;

	public String getBalancePayer() {
		return balancePayer;
	}

	public void setBalancePayer(String balancePayer) {
		this.balancePayer = balancePayer;
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
