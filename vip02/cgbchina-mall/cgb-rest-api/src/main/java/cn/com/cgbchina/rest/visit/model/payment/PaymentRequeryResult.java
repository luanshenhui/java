package cn.com.cgbchina.rest.visit.model.payment;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import javax.validation.constraints.NotNull;

import cn.com.cgbchina.rest.visit.model.BaseResult;

/**
 * Comment: Created by 11150321050126 on 2016/4/29.
 */
public class PaymentRequeryResult extends BaseResult implements Serializable {
	private static final long serialVersionUID = 5912162188466525756L;
	@NotNull
	private String tradeSeqNo;
	@NotNull
	private String orderAmount;

	private List<PaymentRequeryResultInfo> infos = new ArrayList<PaymentRequeryResultInfo>();

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

	public List<PaymentRequeryResultInfo> getInfos() {
		return infos;
	}

	public void setInfos(List<PaymentRequeryResultInfo> infos) {
		this.infos = infos;
	}

}
