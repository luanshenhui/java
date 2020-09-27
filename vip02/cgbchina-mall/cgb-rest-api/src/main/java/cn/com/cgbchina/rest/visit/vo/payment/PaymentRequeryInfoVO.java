package cn.com.cgbchina.rest.visit.vo.payment;

import java.io.Serializable;
import java.util.List;

import cn.com.cgbchina.rest.visit.vo.BaseQueryVo;

/**
 * Comment: Created by 11150321050126 on 2016/4/29.
 */
public class PaymentRequeryInfoVO extends BaseQueryVo implements Serializable {
	private String tradeSeqNo;
	private String remark;
	private String orderAmount;
	private List<OrderBaseInfoVO> orderBaseInfos;

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

	public List<OrderBaseInfoVO> getOrderBaseInfos() {
		return orderBaseInfos;
	}

	public void setOrderBaseInfos(List<OrderBaseInfoVO> orderBaseInfos) {
		this.orderBaseInfos = orderBaseInfos;
	}
}
