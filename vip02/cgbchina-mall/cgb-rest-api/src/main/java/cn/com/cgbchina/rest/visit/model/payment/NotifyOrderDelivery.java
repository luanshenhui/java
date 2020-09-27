package cn.com.cgbchina.rest.visit.model.payment;

import cn.com.cgbchina.rest.visit.model.BaseQuery;

import java.io.Serializable;
import java.util.List;

/**
 * Comment: Created by 11150321050126 on 2016/4/29.
 */
public class NotifyOrderDelivery extends BaseQuery implements Serializable {
	private static final long serialVersionUID = 1622880276643697815L;
	private String tradeSeqNo;
	private String orderAmount;
	private String remark;
	private List<DeliveryOrderInfo> deliveryOrderInfos;

	public List<DeliveryOrderInfo> getDeliveryOrderInfos() {
		return deliveryOrderInfos;
	}

	public void setDeliveryOrderInfos(List<DeliveryOrderInfo> deliveryOrderInfos) {
		this.deliveryOrderInfos = deliveryOrderInfos;
	}

	public String getTradeSeqNo() {
		return tradeSeqNo;
	}

	public void setTradeSeqNo(String tradeSeqNo) {
		this.tradeSeqNo = tradeSeqNo;
	}

	public String getOrderAmount() {
		return orderAmount;
	}

	public void setOrderAmount(String orderAmount) {
		this.orderAmount = orderAmount;
	}

	public String getRemark() {
		return remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}
}
