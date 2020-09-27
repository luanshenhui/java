package cn.com.cgbchina.rest.visit.model.payment;

import cn.com.cgbchina.rest.visit.model.BaseResult;

import java.io.Serializable;

import javax.validation.constraints.NotNull;

/**
 * Comment: Created by 11150321050126 on 2016/4/29.
 */
public class ChannelPayResult extends BaseResult implements Serializable {
	private static final long serialVersionUID = -7461549237864772423L;
	@NotNull
	private String orders;

	public String getOrders() {
		return orders;
	}

	public void setOrders(String orders) {
		this.orders = orders;
	}
}
