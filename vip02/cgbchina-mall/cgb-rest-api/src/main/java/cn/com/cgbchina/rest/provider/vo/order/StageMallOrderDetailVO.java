package cn.com.cgbchina.rest.provider.vo.order;

import java.io.Serializable;

import javax.validation.constraints.NotNull;

import cn.com.cgbchina.rest.common.annotation.XMLNodeName;
import cn.com.cgbchina.rest.provider.vo.BaseQueryEntityVO;

/**
 * @author lizy 2016/4/27. MAL111 订单详细信息查询(分期商城)
 */
public class StageMallOrderDetailVO extends BaseQueryEntityVO implements Serializable {

	private static final long serialVersionUID = 2174227643143613887L;
	@NotNull
	private String origin;
	@NotNull
	private String mallType;
	@XMLNodeName(value = "order_id")
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
