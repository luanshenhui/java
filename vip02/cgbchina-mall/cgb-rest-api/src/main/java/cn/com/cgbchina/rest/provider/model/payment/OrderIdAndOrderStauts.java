package cn.com.cgbchina.rest.provider.model.payment;

import java.io.Serializable;

import cn.com.cgbchina.rest.provider.model.BaseEntity;

/**
 * MAL503 微信发起支付接口list泛型类
 * 
 * @author zjq 2016/6/24.
 */
public class OrderIdAndOrderStauts implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 2406313997877947279L;
	private String orderId;

	private String orderStatusId;

	public String getOrderStatusId() {
		return orderStatusId;
	}

	public void setOrderStatusId(String orderStatusId) {
		this.orderStatusId = orderStatusId;
	}

	public String getOrderId() {
		return orderId;
	}

	public void setOrderId(String orderId) {
		this.orderId = orderId;
	}

}
