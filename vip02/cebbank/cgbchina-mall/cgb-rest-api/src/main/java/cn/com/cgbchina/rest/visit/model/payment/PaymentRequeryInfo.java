package cn.com.cgbchina.rest.visit.model.payment;

import cn.com.cgbchina.rest.visit.model.BaseQuery;

import java.io.Serializable;
import java.util.List;

import javax.validation.constraints.NotNull;

/**
 * Comment: Created by 11150321050126 on 2016/4/29.
 */
public class PaymentRequeryInfo extends BaseQuery implements Serializable {
	private static final long serialVersionUID = 7534288710618349894L;
	@NotNull
	private String tradeSeqNo;
	@NotNull
	private String orderAmount;
	private String remark;
	private List<OrderBaseInfo> orderBaseInfos;

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

	public List<OrderBaseInfo> getOrderBaseInfos() {
		return orderBaseInfos;
	}

	public void setOrderBaseInfos(List<OrderBaseInfo> orderBaseInfos) {
		this.orderBaseInfos = orderBaseInfos;
	}
}
