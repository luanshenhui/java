package cn.com.cgbchina.rest.visit.vo.payment;

import java.io.Serializable;
import java.util.Date;

import cn.com.cgbchina.rest.common.annotation.Special;
import cn.com.cgbchina.rest.visit.vo.BaseQueryVo;

/**
 * Comment: Created by 11150321050126 on 2016/4/29.
 */
public class OrderBaseInfoVO implements Serializable {
	private String orderId;
	@Special("yyyy-MM-dd")
	private Date payDate;
	private String merId;

	public String getOrderId() {
		return orderId;
	}

	public void setOrderId(String orderId) {
		this.orderId = orderId;
	}

	public Date getPayDate() {
		return payDate;
	}

	public void setPayDate(Date payDate) {
		this.payDate = payDate;
	}

	public String getMerId() {
		return merId;
	}

	public void setMerId(String merId) {
		this.merId = merId;
	}
}
