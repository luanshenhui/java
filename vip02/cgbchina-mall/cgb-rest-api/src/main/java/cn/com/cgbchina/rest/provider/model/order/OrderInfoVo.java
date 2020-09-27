package cn.com.cgbchina.rest.provider.model.order;

import cn.com.cgbchina.rest.common.annotation.XMLNodeName;
import cn.com.cgbchina.rest.provider.vo.BaseQueryEntityVO;

/**
 * MAL315 订单支付结果校验接口(分期商城) List泛型类型
 * 
 * @author zjq 2016/6/24.
 */
public class OrderInfoVo extends BaseQueryEntityVO {

	private static final long serialVersionUID = 5925651343597923882L;
	@XMLNodeName(value = "order_id")
	private String orderId;
	@XMLNodeName(value = "cur_status_id")
	private String curStatusId;
	@XMLNodeName(value = "error_code")
	private String errorCode;
	@XMLNodeName(value = "error_code_text")
	private String errorCodeText;
	@XMLNodeName(value = "bpserrorCode")
	private String bpserrorCode;
	@XMLNodeName(value = "bpserrorCode_text")
	private String bpserrorCodeText;
	@XMLNodeName(value = "bpsapproveResult")
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
