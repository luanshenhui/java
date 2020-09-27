package cn.com.cgbchina.rest.provider.model.order;

import java.io.Serializable;

import cn.com.cgbchina.rest.provider.model.BaseQueryEntity;

/**
 * @author lizy 2016/4/27. MAL110 订单撤销退货(分期商城)的订单对象
 */
public class StageMallOrderCancelorRefund extends BaseQueryEntity implements Serializable {
	private static final long serialVersionUID = 8371043439654649726L;
	private String origin;
	private String mallType;
	private String orderMainId;
	private String orderId;
	private String intType;
	private String doDesc;

	public String getCreateReport() {
		return createReport;
	}

	public void setCreateReport(String createReport) {
		this.createReport = createReport;
	}

	public String getPersonFlag() {
		return personFlag;
	}

	public void setPersonFlag(String personFlag) {
		this.personFlag = personFlag;
	}

	public String getDoDesc() {
		return doDesc;
	}

	public void setDoDesc(String doDesc) {
		this.doDesc = doDesc;
	}

	public String getIntType() {
		return intType;
	}

	public void setIntType(String intType) {
		this.intType = intType;
	}

	public String getOrderId() {
		return orderId;
	}

	public void setOrderId(String orderId) {
		this.orderId = orderId;
	}

	public String getOrderMainId() {
		return orderMainId;
	}

	public void setOrderMainId(String orderMainId) {
		this.orderMainId = orderMainId;
	}

	public String getMallType() {
		return mallType;
	}

	public void setMallType(String mallType) {
		this.mallType = mallType;
	}

	public String getOrigin() {
		return origin;
	}

	public void setOrigin(String origin) {
		this.origin = origin;
	}

	private String personFlag;
	private String createReport;

}
