package cn.com.cgbchina.rest.provider.vo.order;

import java.io.Serializable;

import javax.validation.constraints.NotNull;

import cn.com.cgbchina.rest.provider.vo.BaseEntityVO;

/**
 * MAL105 CC积分商城订单列表的返回对象
 * 
 * @author Lizy
 *
 */
public class CCIntergralOrderVO extends BaseEntityVO implements Serializable {
	private static final long serialVersionUID = 1587000256395305879L;
	@NotNull
	private String orderMainId;
	@NotNull
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
