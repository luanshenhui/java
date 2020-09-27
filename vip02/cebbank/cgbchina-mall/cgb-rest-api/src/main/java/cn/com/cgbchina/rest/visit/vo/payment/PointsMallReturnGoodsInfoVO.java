package cn.com.cgbchina.rest.visit.vo.payment;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;

import cn.com.cgbchina.rest.common.annotation.XMLNodeName;
import cn.com.cgbchina.rest.visit.vo.BaseQueryVo;

/**
 * Comment: Created by 11150321050126 on 2016/4/29.
 */
public class PointsMallReturnGoodsInfoVO extends BaseQueryVo implements Serializable {
	private String channel;
	private String orderNumber;
	private String orderId;
	private Date orderTime;
	private Date operTime;
	private String acrdNo;
	private BigDecimal tradeMoney;
	private BigDecimal cashMoney;
	private BigDecimal integralMoney;
	private String merId;
	@XMLNodeName("MERNO")
	private String MERNO;
	private String qsvendorNo;
	private String categoryNo;
	private String orderNbr;
	private String stagesNum;
	private String operId;
	private String payee;

	public String getOperId() {
		return operId;
	}

	public void setOperId(String operId) {
		this.operId = operId;
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

	public String getOrderNumber() {
		return orderNumber;
	}

	public void setOrderNumber(String orderNumber) {
		this.orderNumber = orderNumber;
	}

	public String getOrderId() {
		return orderId;
	}

	public void setOrderId(String orderId) {
		this.orderId = orderId;
	}

	public Date getOrderTime() {
		return orderTime;
	}

	public void setOrderTime(Date orderTime) {
		this.orderTime = orderTime;
	}

	public Date getOperTime() {
		return operTime;
	}

	public void setOperTime(Date operTime) {
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

	public String getMERNO() {
		return MERNO;
	}

	public void setMERNO(String MERNO) {
		this.MERNO = MERNO;
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
}
