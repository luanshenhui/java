package cn.com.cgbchina.rest.provider.vo.order;

import javax.validation.constraints.NotNull;

import cn.com.cgbchina.rest.provider.vo.BaseQueryEntityVO;

/**
 * MAL502 微信退积分接口
 * 
 * @author lizy 2016/4/28.
 */
public class WXIntergralVO extends BaseQueryEntityVO {

	/**
	 * 
	 */
	private static final long serialVersionUID = -5317170844500469701L;
	@NotNull
	private String orderMainId;
	@NotNull
	private String backMoney;
	@NotNull
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
