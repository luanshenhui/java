package cn.com.cgbchina.rest.provider.vo.order;

import javax.validation.constraints.NotNull;

import cn.com.cgbchina.rest.common.annotation.XMLNodeName;
import cn.com.cgbchina.rest.provider.vo.BaseEntityVO;
import cn.com.cgbchina.rest.provider.vo.BaseVO;

/**
 * MAL325 积分商城支付校验接口
 * 
 * @author lizy 2016/4/28.
 */
public class IntergrallPayVerificationVO extends BaseVO {

	/**
	 * 
	 */
	private static final long serialVersionUID = -3507034094026520671L;
	@NotNull
	private String origin;
	@NotNull
	@XMLNodeName(value = "ordermain_id")
	private String ordermainId;
	@NotNull
	private String payAccountNo;
	@NotNull
	private String cardType;
	@NotNull
	private String orders;
	@NotNull
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
