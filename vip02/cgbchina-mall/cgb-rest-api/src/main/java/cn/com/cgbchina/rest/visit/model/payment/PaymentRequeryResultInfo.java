package cn.com.cgbchina.rest.visit.model.payment;

import java.io.Serializable;
import java.util.Date;

import cn.com.cgbchina.rest.common.annotation.Special;

public class PaymentRequeryResultInfo implements Serializable {
	/**
	 * 
	 */
	private static final long serialVersionUID = -5825417967480371863L;
	public String orderId;
	public String tradeStatus;
	public String handleStatus;
	public String payAccountNo;
	@Special("yyyyMMddHHmmss")
	public Date payTime;

	public String getOrderId() {
		return orderId;
	}

	public void setOrderId(String orderId) {
		this.orderId = orderId;
	}

	public String getTradeStatus() {
		return tradeStatus;
	}

	public void setTradeStatus(String tradeStatus) {
		this.tradeStatus = tradeStatus;
	}

	public String getHandleStatus() {
		return handleStatus;
	}

	public void setHandleStatus(String handleStatus) {
		this.handleStatus = handleStatus;
	}

	public String getPayAccountNo() {
		return payAccountNo;
	}

	public void setPayAccountNo(String payAccountNo) {
		this.payAccountNo = payAccountNo;
	}

	public Date getPayTime() {
		return payTime;
	}

	public void setPayTime(Date payTime) {
		this.payTime = payTime;
	}

}