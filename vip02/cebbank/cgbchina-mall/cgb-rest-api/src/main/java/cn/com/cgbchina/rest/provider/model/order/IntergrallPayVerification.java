package cn.com.cgbchina.rest.provider.model.order;

import cn.com.cgbchina.rest.provider.model.BaseQueryEntity;

/**
 * MAL325 积分商城支付校验接口
 * 
 * @author lizy 2016/4/28.
 */
public class IntergrallPayVerification extends BaseQueryEntity {

	/**
	 * 
	 */
	private static final long serialVersionUID = -3507034094026520671L;
	private String origin;
	private String ordermainId;
	private String payAccountNo;
	private String cardType;
	private String orders;
	private String crypt;

	public String getOrigin() {
		return origin;
	}

	public void setOrigin(String origin) {
		this.origin = origin;
	}

	public String getOrdermainId() {
		return ordermainId;
	}

	public void setOrdermainId(String ordermainId) {
		this.ordermainId = ordermainId;
	}

	public String getPayAccountNo() {
		return payAccountNo;
	}

	public void setPayAccountNo(String payAccountNo) {
		this.payAccountNo = payAccountNo;
	}

	public String getCardType() {
		return cardType;
	}

	public void setCardType(String cardType) {
		this.cardType = cardType;
	}

	public String getOrders() {
		return orders;
	}

	public void setOrders(String orders) {
		this.orders = orders;
	}

	public String getCrypt() {
		return crypt;
	}

	public void setCrypt(String crypt) {
		this.crypt = crypt;
	}

}
