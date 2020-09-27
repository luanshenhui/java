package cn.com.cgbchina.rest.provider.vo.order;

import java.io.Serializable;

import javax.validation.constraints.NotNull;

import cn.com.cgbchina.rest.common.annotation.XMLNodeName;
import cn.com.cgbchina.rest.provider.vo.BaseQueryEntityVO;

/**
 * MAL112 订单状态修改(分期商城) 的修改对象
 * 
 * @author lizy 2016/4/28.
 */
public class StageMallOrderUpdateStateVO extends BaseQueryEntityVO implements Serializable {
	private static final long serialVersionUID = -3193175262760027801L;
	@NotNull
	private String origin;
	@NotNull
	private String mallType;
	@NotNull
	private String orderId;
	@NotNull
	@XMLNodeName(value="cur_status_id")
	private String curStatusId;
	@XMLNodeName(value="ordernbr")
	private String orderNbr;
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
	public String getCurStatusId() {
		return curStatusId;
	}
	public void setCurStatusId(String curStatusId) {
		this.curStatusId = curStatusId;
	}
	public String getOrderNbr() {
		return orderNbr;
	}
	public void setOrderNbr(String orderNbr) {
		this.orderNbr = orderNbr;
	}
	
}
