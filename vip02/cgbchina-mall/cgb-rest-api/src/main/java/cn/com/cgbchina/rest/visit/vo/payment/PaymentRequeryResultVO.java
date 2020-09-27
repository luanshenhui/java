package cn.com.cgbchina.rest.visit.vo.payment;

import cn.com.cgbchina.rest.visit.model.payment.PaymentRequeryResultInfo;
import cn.com.cgbchina.rest.visit.vo.BaseResultVo;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import javax.validation.constraints.NotNull;

/**
 * Comment: Created by 11150321050126 on 2016/4/29.
 */
public class PaymentRequeryResultVO extends BaseResultVo implements Serializable {
	@NotNull
	private String tradeSeqNo;
	@NotNull
	private String orderAmount;

	private List<PaymentRequeryResultInfoVO> infos = new ArrayList<PaymentRequeryResultInfoVO>();

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

	public List<PaymentRequeryResultInfoVO> getInfos() {
		return infos;
	}

	public void setInfos(List<PaymentRequeryResultInfoVO> infos) {
		this.infos = infos;
	}

}
