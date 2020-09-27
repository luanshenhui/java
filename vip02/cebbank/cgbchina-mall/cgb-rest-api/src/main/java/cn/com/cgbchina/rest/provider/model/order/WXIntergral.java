package cn.com.cgbchina.rest.provider.model.order;

import cn.com.cgbchina.rest.provider.model.BaseQueryEntity;

/**
 * MAL502 微信退积分接口
 * 
 * @author lizy 2016/4/28.
 */
public class WXIntergral extends BaseQueryEntity {

	/**
	 * 
	 */
	private static final long serialVersionUID = -5317170844500469701L;
	private String orderMainId;
	private String backMoney;
	private String backPoint;

	public String getOrderMainId() {
		return orderMainId;
	}

	public void setOrderMainId(String orderMainId) {
		this.orderMainId = orderMainId;
	}

	public String getBackMoney() {
		return backMoney;
	}

	public void setBackMoney(String backMoney) {
		this.backMoney = backMoney;
	}

	public String getBackPoint() {
		return backPoint;
	}

	public void setBackPoint(String backPoint) {
		this.backPoint = backPoint;
	}

}
