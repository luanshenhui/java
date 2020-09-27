package cn.com.cgbchina.rest.visit.vo.payment;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;

import cn.com.cgbchina.rest.common.annotation.Special;
import cn.com.cgbchina.rest.common.annotation.XMLNodeName;
import cn.com.cgbchina.rest.visit.vo.BaseQueryVo;

/**
 * Comment: Created by 11150321050126 on 2016/4/29.
 */
public class PointsMallReqMoneyInfoVO extends BaseQueryVo implements Serializable {
	private String channel;
	private String orderNumber;
	private String orderId;
	@Special("yyyyMMddHHmmss")
	private Date orderTime;
	@Special("yyyyMMddHHmmss")
	private Date operTime;
	private String acrdNo;
	private BigDecimal tradeMoney;
	private BigDecimal cashMoney;
	private BigDecimal integralMoney;
	private String merId;
	@XMLNodeName("MERNO")
	private String mERNO;
	private String qsvendorNo;
	private String categoryNo;
	private String orderNbr;
	private String stagesNum;
	private String operId;

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
		return mERNO;
	}

	public void setMERNO(String mERNO) {
		this.mERNO = mERNO;
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
}
