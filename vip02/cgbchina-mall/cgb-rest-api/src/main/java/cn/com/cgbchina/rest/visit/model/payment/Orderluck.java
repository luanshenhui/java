package cn.com.cgbchina.rest.visit.model.payment;

import java.io.Serializable;

import javax.validation.constraints.NotNull;

import cn.com.cgbchina.rest.visit.model.BaseQuery;

/**
 * Comment: Created by 11150321050126 on 2016/4/29.
 */
public class Orderluck extends BaseQuery implements Serializable {
	private static final long serialVersionUID = 8062635685307738519L;
	@NotNull
	private String orderId;

	public String getOrderId() {
		return orderId;
	}

	public void setOrderId(String orderId) {
		this.orderId = orderId;
	}

}
