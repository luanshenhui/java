package cn.com.cgbchina.rest.visit.vo.payment;

import cn.com.cgbchina.rest.visit.vo.BaseQueryVo;

import java.io.Serializable;

/**
 * Comment: Created by 11150321050126 on 2016/4/29.
 */
public class CCPointsPayBaseInfoVO extends BaseQueryVo implements Serializable {
	private String fracCardNo;
	private String fracAmount;
	private String fracType;
	private String fracValidDate;

	public String getFracCardNo() {
		return fracCardNo;
	}

	public void setFracCardNo(String fracCardNo) {
		this.fracCardNo = fracCardNo;
	}

	public String getFracAmount() {
		return fracAmount;
	}

	public void setFracAmount(String fracAmount) {
		this.fracAmount = fracAmount;
	}

	public String getFracType() {
		return fracType;
	}

	public void setFracType(String fracType) {
		this.fracType = fracType;
	}

	public String getFracValidDate() {
		return fracValidDate;
	}

	public void setFracValidDate(String fracValidDate) {
		this.fracValidDate = fracValidDate;
	}
}
