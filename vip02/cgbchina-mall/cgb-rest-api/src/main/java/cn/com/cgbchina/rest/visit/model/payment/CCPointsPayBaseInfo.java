package cn.com.cgbchina.rest.visit.model.payment;

import cn.com.cgbchina.rest.visit.model.BaseQuery;

import java.io.Serializable;

import javax.validation.constraints.NotNull;

/**
 * Comment: Created by 11150321050126 on 2016/4/29.
 */
public class CCPointsPayBaseInfo implements Serializable {
	private static final long serialVersionUID = -1614633059741715099L;
	private String fracCardNo;
	private String fracAmount;
	private String fracType;
	@NotNull
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
