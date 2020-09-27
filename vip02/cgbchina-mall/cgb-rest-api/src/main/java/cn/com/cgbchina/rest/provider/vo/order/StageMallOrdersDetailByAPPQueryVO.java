package cn.com.cgbchina.rest.provider.vo.order;

import java.io.Serializable;

import javax.validation.constraints.NotNull;

import cn.com.cgbchina.rest.common.annotation.XMLNodeName;
import cn.com.cgbchina.rest.provider.vo.BaseQueryEntityVO;

/**
 * MAL309 订单详细信息查询(分期商城)App
 * 
 * @author Lizy
 *
 */
public class StageMallOrdersDetailByAPPQueryVO extends BaseQueryEntityVO implements Serializable {
	private static final long serialVersionUID = 5864670884262629082L;
	@NotNull
	private String origin;
	@XMLNodeName("order_id")
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
