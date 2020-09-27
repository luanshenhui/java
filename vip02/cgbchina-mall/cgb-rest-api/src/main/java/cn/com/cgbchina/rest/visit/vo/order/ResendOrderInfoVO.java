package cn.com.cgbchina.rest.visit.vo.order;

import cn.com.cgbchina.rest.common.annotation.XMLNodeName;
import cn.com.cgbchina.rest.visit.vo.BaseQueryVo;

import java.io.Serializable;

/**
 * Comment: Created by 11150321050126 on 2016/4/30.
 */
public class ResendOrderInfoVO extends BaseQueryVo implements Serializable {
	/**
	 * 
	 */
	private static final long serialVersionUID = 8034633180941788915L;
	@XMLNodeName("orderno")
	private String orderNo;
	@XMLNodeName("suborderno")
	private String subOrderNo;
	@XMLNodeName("mobile")
	private String mobile;
	private String vendorName;

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

	public String getVendorName() {
		return vendorName;
	}

	public void setVendorName(String vendorName) {
		this.vendorName = vendorName;
	}
	
}
