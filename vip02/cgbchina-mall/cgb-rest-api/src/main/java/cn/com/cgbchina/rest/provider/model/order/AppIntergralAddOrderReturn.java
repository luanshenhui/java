
package cn.com.cgbchina.rest.provider.model.order;

import cn.com.cgbchina.rest.provider.model.BaseEntity;

/**
 * MAL314 下单接口(分期商城)
 * 
 * @author lizy 2016/4/28.
 */
public class AppIntergralAddOrderReturn extends BaseEntity {

	/**
	 * 
	 */
	private static final long serialVersionUID = 3337633457176114581L;
	private String ordermainId;
	private String amount;
	private String merchId;
	private String payType;
	private String tradeDate;
	private String tradeTime;
	private String orders;
	private String sign;

	public String getOrdermainId() {
		return ordermainId;
	}

	public void setOrdermainId(String ordermainId) {
		this.ordermainId = ordermainId;
	}

	public String getAmount() {
		return amount;
	}

	public void setAmount(String amount) {
		this.amount = amount;
	}

	public String getMerchId() {
		return merchId;
	}

	public void setMerchId(String merchId) {
		this.merchId = merchId;
	}

	public String getPayType() {
		return payType;
	}

	public void setPayType(String payType) {
		this.payType = payType;
	}

	public String getTradeDate() {
		return tradeDate;
	}

	public void setTradeDate(String tradeDate) {
		this.tradeDate = tradeDate;
	}

	public String getTradeTime() {
		return tradeTime;
	}

	public void setTradeTime(String tradeTime) {
		this.tradeTime = tradeTime;
	}

	public String getOrders() {
		return orders;
	}

	public void setOrders(String orders) {
		this.orders = orders;
	}

	public String getSign() {
		return sign;
	}

	public void setSign(String sign) {
		this.sign = sign;
	}

}
