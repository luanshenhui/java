package cn.com.cgbchina.rest.provider.model.order;

import java.util.ArrayList;
import java.util.List;

import cn.com.cgbchina.rest.provider.model.BaseEntity;

/**
 * MAL325 积分商城支付校验接口
 * 
 * @author lizy 2016/4/28.
 */
public class IntergrallPayVerificationReturn extends BaseEntity {

	/**
	 * 
	 */
	private static final long serialVersionUID = 3286706569724688597L;
	private List<IntergrallPayVerificationOrderInfo> ordersInfo = new ArrayList<IntergrallPayVerificationOrderInfo>();

	public List<IntergrallPayVerificationOrderInfo> getOrdersInfo() {
		return ordersInfo;
	}

	public void setOrdersInfo(
			List<IntergrallPayVerificationOrderInfo> ordersInfo) {
		this.ordersInfo = ordersInfo;
	}

}
