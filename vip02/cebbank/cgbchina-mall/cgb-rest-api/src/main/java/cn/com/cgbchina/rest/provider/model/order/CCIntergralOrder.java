package cn.com.cgbchina.rest.provider.model.order;

import java.io.Serializable;

import cn.com.cgbchina.rest.provider.model.BaseEntity;

/**
 * MAL105 CC积分商城订单列表的返回对象
 * 
 * @author Lizy
 *
 */
public class CCIntergralOrder extends BaseEntity implements Serializable {
	private static final long serialVersionUID = 1587000256395305879L;
	private String orderMainId;
	private String acceptedNo;

	public String getOrderMainId() {
		return orderMainId;
	}

	public void setOrderMainId(String orderMainId) {
		this.orderMainId = orderMainId;
	}

	public String getAcceptedNo() {
		return acceptedNo;
	}

	public void setAcceptedNo(String acceptedNo) {
		this.acceptedNo = acceptedNo;
	}
}
