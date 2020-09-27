package cn.com.cgbchina.rest.provider.model.order;

import java.io.Serializable;

import cn.com.cgbchina.rest.provider.model.BaseQueryEntity;

/**
 * MAL309 订单详细信息查询(分期商城)App
 * 
 * @author Lizy
 *
 */
public class StageMallOrdersDetailByAPPQuery extends BaseQueryEntity implements Serializable {
	private static final long serialVersionUID = 5864670884262629082L;
	private String origin;
	private String orderId;

	public String getOrigin() {
		return origin;
	}

	public void setOrigin(String origin) {
		this.origin = origin;
	}

	public String getOrderId() {
		return orderId;
	}

	public void setOrderId(String orderId) {
		this.orderId = orderId;
	}

}
