package cn.com.cgbchina.rest.provider.model.order;

import cn.com.cgbchina.rest.provider.model.BaseEntity;

/**
 * MAL325 积分商城支付校验接口 订单信息
 * 
 * @author lizy 2016/4/28.
 */
public class IntergrallPayVerificationOrderInfo extends BaseEntity {

	/**
	 * 
	 */
	private static final long serialVersionUID = -367027740072983470L;
	private String orderId;
	private String cur_statusId;
	private String errorCode;
	private String errorCodeText;

	public String getOrderId() {
		return orderId;
	}

	public void setOrderId(String orderId) {
		this.orderId = orderId;
	}

	public String getCur_statusId() {
		return cur_statusId;
	}

	public void setCur_statusId(String cur_statusId) {
		this.cur_statusId = cur_statusId;
	}

	public String getErrorCode() {
		return errorCode;
	}

	public void setErrorCode(String errorCode) {
		this.errorCode = errorCode;
	}

	public String getErrorCodeText() {
		return errorCodeText;
	}

	public void setErrorCodeText(String errorCodeText) {
		this.errorCodeText = errorCodeText;
	}
}
