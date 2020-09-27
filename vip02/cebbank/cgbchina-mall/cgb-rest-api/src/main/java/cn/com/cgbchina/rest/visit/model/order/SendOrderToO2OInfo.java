package cn.com.cgbchina.rest.visit.model.order;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

import javax.validation.constraints.NotNull;

import cn.com.cgbchina.rest.visit.model.BaseQuery;

/**
 * Comment: Created by 11150321050126 on 2016/4/30.
 */
public class SendOrderToO2OInfo extends BaseQuery implements Serializable {

	private static final long serialVersionUID = 1594450624450760709L;
	private String vendorName;

	private BigDecimal payment;
	@NotNull
	private String organId;
	private List<O2OOrderInfo> o2OOrderInfos = new ArrayList<O2OOrderInfo>();

	public String getVendorName() {
		return vendorName;
	}

	public void setVendorName(String vendorName) {
		this.vendorName = vendorName;
	}

	public BigDecimal getPayment() {
		return payment;
	}

	public void setPayment(BigDecimal payment) {
		this.payment = payment;
	}

	public String getOrganId() {
		return organId;
	}

	public void setOrganId(String organId) {
		this.organId = organId;
	}

	public List<O2OOrderInfo> getO2OOrderInfos() {
		return o2OOrderInfos;
	}

	public void setO2OOrderInfos(List<O2OOrderInfo> o2OOrderInfos) {
		this.o2OOrderInfos = o2OOrderInfos;
	}
}
