package cn.com.cgbchina.rest.visit.vo.payment;

import cn.com.cgbchina.rest.visit.vo.BaseQueryVo;

import java.io.Serializable;
import java.util.List;

/**
 * Comment: Created by 11150321050126 on 2016/4/29.
 */
public class NotifyOrderDeliveryVO extends BaseQueryVo implements Serializable {
	private String tradeSeqNo;
	private String orderAmount;
	private String remark;
	private List<DeliveryOrderInfoVO> deliveryOrderInfos;

	public List<DeliveryOrderInfoVO> getDeliveryOrderInfos() {
		return deliveryOrderInfos;
	}

	public void setDeliveryOrderInfos(List<DeliveryOrderInfoVO> deliveryOrderInfos) {
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
