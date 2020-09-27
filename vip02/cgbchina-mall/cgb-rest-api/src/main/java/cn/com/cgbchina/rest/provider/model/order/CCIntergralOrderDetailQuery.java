package cn.com.cgbchina.rest.provider.model.order;

import java.io.Serializable;

import cn.com.cgbchina.rest.provider.model.BaseQueryEntity;

/**
 * MAL108 CC积分商城订单详细信息查询
 * 
 * @author lizy
 */
public class CCIntergralOrderDetailQuery extends BaseQueryEntity implements Serializable {
	private static final long serialVersionUID = 5797952956988578341L;
	private String orderMainId;

	public String getOrderMainId() {
		return orderMainId;
	}

	public void setOrderMainId(String orderMainId) {
		this.orderMainId = orderMainId;
	}
}
