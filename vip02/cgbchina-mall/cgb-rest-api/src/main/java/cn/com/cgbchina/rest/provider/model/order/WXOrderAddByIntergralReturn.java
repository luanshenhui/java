package cn.com.cgbchina.rest.provider.model.order;

import java.io.Serializable;

import cn.com.cgbchina.rest.provider.model.BaseEntity;

/**
 * MAL501 微信生成订单接口（积分）
 * 
 * @author lizy 2016/4/28.
 */
public class WXOrderAddByIntergralReturn extends BaseEntity implements
		Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = -5273826832929390547L;
	private String orderMainId;
	private String curStatusId;

	public String getCurStatusId() {
		return curStatusId;
	}

	public void setCurStatusId(String curStatusId) {
		this.curStatusId = curStatusId;
	}

	public String getOrderMainId() {
		return orderMainId;
	}

	public void setOrderMainId(String orderMainId) {
		this.orderMainId = orderMainId;
	}

}
