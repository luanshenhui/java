package cn.com.cgbchina.rest.visit.vo.order;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

import cn.com.cgbchina.rest.common.annotation.XMLNodeName;
import cn.com.cgbchina.rest.visit.vo.BaseQueryVo;

/**
 * Comment: Created by 11150321050126 on 2016/4/30.
 */
public class SendOrderToO2OInfoVO extends BaseQueryVo implements Serializable {
	private String orderno;
	private Integer sum;
	private BigDecimal payment;
	@XMLNodeName("organ_id")
	private String organId;
	private List<O2OOrderInfoVO> o2OOrderInfos = new ArrayList<O2OOrderInfoVO>();

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

	public List<O2OOrderInfoVO> getO2OOrderInfos() {
		return o2OOrderInfos;
	}

	public void setO2OOrderInfos(List<O2OOrderInfoVO> o2OOrderInfos) {
		this.o2OOrderInfos = o2OOrderInfos;
	}

	public String getOrderno() {
		return orderno;
	}

	public void setOrderno(String orderno) {
		this.orderno = orderno;
	}

	public Integer getSum() {
		return sum;
	}

	public void setSum(Integer sum) {
		this.sum = sum;
	}
}
