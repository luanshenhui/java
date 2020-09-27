package cn.com.cgbchina.rest.provider.vo.order;

import cn.com.cgbchina.rest.common.annotation.XMLNodeName;
import cn.com.cgbchina.rest.provider.vo.BaseEntityVO;

/**
 * MAL324 积分商城下单
 * 
 * @author lizy 2016/4/28.
 */
public class IntergralAddOrderReturnVO extends BaseEntityVO {

	/**
	 * 
	 */
	private static final long serialVersionUID = 7514115755639292732L;
	@XMLNodeName(value = "ordermain_id")
	private String ordermainId;
	private String serialNo;
	private String jfType;
	private String amountMoney;
	private String amountPoint;
	private String merchId;
	private String isMerge;
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

	public String getSerialNo() {
		return serialNo;
	}

	public void setSerialNo(String serialNo) {
		this.serialNo = serialNo;
	}

	public String getJfType() {
		return jfType;
	}

	public void setJfType(String jfType) {
		this.jfType = jfType;
	}

	public String getAmountMoney() {
		return amountMoney;
	}

	public void setAmountMoney(String amountMoney) {
		this.amountMoney = amountMoney;
	}

	public String getAmountPoint() {
		return amountPoint;
	}

	public void setAmountPoint(String amountPoint) {
		this.amountPoint = amountPoint;
	}

	public String getMerchId() {
		return merchId;
	}

	public void setMerchId(String merchId) {
		this.merchId = merchId;
	}

	public String getIsMerge() {
		return isMerge;
	}

	public void setIsMerge(String isMerge) {
		this.isMerge = isMerge;
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
