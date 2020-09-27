package cn.com.cgbchina.rest.provider.model.order;

import java.io.Serializable;

import cn.com.cgbchina.rest.provider.model.BaseQueryEntity;

/**
 * @author lizy 2016/4/27. MAL111 订单详细信息查询(分期商城)
 */
public class StageMallOrderDetail extends BaseQueryEntity implements Serializable {

	private static final long serialVersionUID = 2174227643143613887L;
	private String origin;
	private String mallType;
	private String orderId;

	public String getOrigin() {
		return origin;
	}

	public void setOrigin(String origin) {
		this.origin = origin;
	}

	public String getMallType() {
		return mallType;
	}

	public void setMallType(String mallType) {
		this.mallType = mallType;
	}

	public String getOrderId() {
		return orderId;
	}

	public void setOrderId(String orderId) {
		this.orderId = orderId;
	}

}
