package cn.com.cgbchina.user.model;

import java.io.Serializable;

/**
 * Created by 11150721040343 on 16-4-12.
 */
public class OrderInfo implements Serializable {

	private static final long serialVersionUID = 3889780383860779610L;
	private String id;// 商品id
	private String name;// 商品名称
	private float orderValue;// 订单金额（元）
	private int count;// 数量
	private String service;// 售后
	private float payment;// 订单实付（元）
	private String orderState;// 请款状态

	public String getId() {
		return id;
	}

	public String getName() {
		return name;
	}

	public float getOrderValue() {
		return orderValue;
	}

	public int getCount() {
		return count;
	}

	public String getService() {
		return service;
	}

	public float getPayment() {
		return payment;
	}

	public String getOrderState() {
		return orderState;
	}

	public void setId(String id) {
		this.id = id;
	}

	public void setName(String name) {
		this.name = name;
	}

	public void setService(String service) {
		this.service = service;
	}

	public void setPayment(float payment) {
		this.payment = payment;
	}

	public void setOrderState(String orderState) {
		this.orderState = orderState;
	}

	public void setOrderValue(float orderValue) {
		this.orderValue = orderValue;
	}

	public void setCount(int count) {
		this.count = count;
	}
}
