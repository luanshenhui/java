package cn.com.cgbchina.rest.visit.vo.order;

import cn.com.cgbchina.rest.visit.vo.BaseQueryVo;

import java.io.Serializable;

/**
 * Comment: Created by 11150321050126 on 2016/4/30.
 */
public class ResendOrderInfoVO extends BaseQueryVo implements Serializable {
	private String orderNo;
	private String subOrderNo;
	private String mobile;

	public String getOrderNo() {
		return orderNo;
	}

	public void setOrderNo(String orderNo) {
		this.orderNo = orderNo;
	}

	public String getSubOrderNo() {
		return subOrderNo;
	}

	public void setSubOrderNo(String subOrderNo) {
		this.subOrderNo = subOrderNo;
	}

	public String getMobile() {
		return mobile;
	}

	public void setMobile(String mobile) {
		this.mobile = mobile;
	}
}
