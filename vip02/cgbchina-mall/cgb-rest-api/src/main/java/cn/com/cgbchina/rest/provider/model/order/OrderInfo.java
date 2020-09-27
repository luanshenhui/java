package cn.com.cgbchina.rest.provider.model.order;

import cn.com.cgbchina.rest.provider.vo.BaseQueryEntityVO;

/**
 * MAL315 订单支付结果校验接口(分期商城) List泛型类型
 * 
 * @author zjq 2016/6/24.
 */
public class OrderInfo extends BaseQueryEntityVO {

	private static final long serialVersionUID = -1L;
	private String orderId;
	private String curStatusId;
	private String errorCode;
	private String errorCodeText;
	private String bpserrorCode;
	private String bpserrorCodeText;
	private String bpsapproveResult;

	public String getOrderId() {
		return orderId;
	}

	public void setOrderId(String orderId) {
		this.orderId = orderId;
	}

	public String getCurStatusId() {
		return curStatusId;
	}

	public void setCurStatusId(String curStatusId) {
		this.curStatusId = curStatusId;
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

	public String getBpserrorCode() {
		return bpserrorCode;
	}

	public void setBpserrorCode(String bpserrorCode) {
		this.bpserrorCode = bpserrorCode;
	}

	public String getBpserrorCodeText() {
		return bpserrorCodeText;
	}

	public void setBpserrorCodeText(String bpserrorCodeText) {
		this.bpserrorCodeText = bpserrorCodeText;
	}

	public String getBpsapproveResult() {
		return bpsapproveResult;
	}

	public void setBpsapproveResult(String bpsapproveResult) {
		this.bpsapproveResult = bpsapproveResult;
	}
}
