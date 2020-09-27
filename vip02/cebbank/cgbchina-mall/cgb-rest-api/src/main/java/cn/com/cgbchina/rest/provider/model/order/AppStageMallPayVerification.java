package cn.com.cgbchina.rest.provider.model.order;

import cn.com.cgbchina.rest.provider.model.BaseQueryEntity;

/**
 * MAL315 订单支付结果校验接口(分期商城)
 * 
 * @author lizy 2016/4/28.
 */
public class AppStageMallPayVerification extends BaseQueryEntity {

	/**
	 * 
	 */
	private static final long serialVersionUID = 5925651343597923882L;
	private String origin;
	private String mallType;
	private String ordermainId;
	private String payAccountNo;
	private String cardType;
	private String optFlag;
	private String orders;
	private String crypt;
	private String doDate;
	private String doTime;

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

	public String getOptFlag() {
		return optFlag;
	}

	public void setOptFlag(String optFlag) {
		this.optFlag = optFlag;
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

	public String getDoDate() {
		return doDate;
	}

	public void setDoDate(String doDate) {
		this.doDate = doDate;
	}

	public String getDoTime() {
		return doTime;
	}

	public void setDoTime(String doTime) {
		this.doTime = doTime;
	}

}
