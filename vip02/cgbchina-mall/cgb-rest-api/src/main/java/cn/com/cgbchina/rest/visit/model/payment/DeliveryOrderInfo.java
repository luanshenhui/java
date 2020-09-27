package cn.com.cgbchina.rest.visit.model.payment;

import cn.com.cgbchina.rest.visit.model.BaseQuery;

import java.io.Serializable;
import java.util.Date;

/**
 * Comment: Created by 11150321050126 on 2016/4/29.
 */
public class DeliveryOrderInfo implements Serializable {
	private static final long serialVersionUID = -4772557185964399183L;
	private String merId;
	private String orderId;
	private String handleStatus;
	private Date payDate;

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

	public String getHandleStatus() {
		return handleStatus;
	}

	public void setHandleStatus(String handleStatus) {
		this.handleStatus = handleStatus;
	}

	public Date getPayDate() {
		return payDate;
	}

	public void setPayDate(Date payDate) {
		this.payDate = payDate;
	}
}
