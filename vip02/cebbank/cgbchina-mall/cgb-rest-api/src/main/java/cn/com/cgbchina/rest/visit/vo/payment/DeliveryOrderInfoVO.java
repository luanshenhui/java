package cn.com.cgbchina.rest.visit.vo.payment;

import cn.com.cgbchina.rest.visit.vo.BaseQueryVo;

import java.io.Serializable;
import java.util.Date;

/**
 * Comment: Created by 11150321050126 on 2016/4/29.
 */
public class DeliveryOrderInfoVO extends BaseQueryVo implements Serializable {
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
