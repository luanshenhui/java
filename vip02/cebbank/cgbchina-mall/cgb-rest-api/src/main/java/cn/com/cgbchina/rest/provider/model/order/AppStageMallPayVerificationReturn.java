package cn.com.cgbchina.rest.provider.model.order;

import java.io.Serializable;
import java.util.List;

import cn.com.cgbchina.rest.provider.model.BaseEntity;

/**
 * MAL315 订单支付结果校验接口(分期商城)
 * 
 * @author lizy 2016/4/28.
 */
public class AppStageMallPayVerificationReturn extends BaseEntity implements
		Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = -3385774749610312891L;
	private List<OrderInfo> orderInfo;

	public List<OrderInfo> getOrderInfo() {
		return orderInfo;
	}

	public void setOrderInfo(List<OrderInfo> orderInfo) {
		this.orderInfo = orderInfo;
	}
}
