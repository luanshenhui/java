
package cn.com.cgbchina.rest.provider.vo.order;

import javax.validation.constraints.NotNull;

import cn.com.cgbchina.rest.common.annotation.XMLNodeName;
import cn.com.cgbchina.rest.provider.vo.BaseEntityVO;

/**
 * MAL314 下单接口(分期商城)
 * 
 * @author lizy 2016/4/28.
 */
public class AppIntergralAddOrderReturnVO extends BaseEntityVO {

	/**
	 * 
	 */
	private static final long serialVersionUID = 3337633457176114581L;
	@NotNull
	@XMLNodeName(value = "ordermain_id")
	private String ordermainId;
	@NotNull
	private String amount;
	@NotNull
	private String merchId;
	@NotNull
	private String payType;
	@NotNull
	private String tradeDate;
	@NotNull
	private String tradeTime;
	@NotNull
	private String orders;
	@NotNull
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
