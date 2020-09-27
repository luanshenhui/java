package cn.com.cgbchina.rest.provider.vo.order;

import java.io.Serializable;

import javax.validation.constraints.NotNull;

import cn.com.cgbchina.rest.provider.vo.BaseQueryEntityVO;

/**
 * MAL108 CC积分商城订单详细信息查询
 * 
 * @author lizy
 */
public class CCIntergralOrderDetailQueryVO extends BaseQueryEntityVO implements Serializable {
	private static final long serialVersionUID = 5797952956988578341L;
	@NotNull
	private String orderMainId;

	public String getOrderMainId() {
		return orderMainId;
	}

	public void setOrderMainId(String orderMainId) {
		this.orderMainId = orderMainId;
	}
}
