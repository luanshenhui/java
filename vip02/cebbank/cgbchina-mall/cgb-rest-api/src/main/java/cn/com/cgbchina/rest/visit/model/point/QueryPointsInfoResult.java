package cn.com.cgbchina.rest.visit.model.point;

import cn.com.cgbchina.rest.visit.model.BaseResult;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;

/**
 * Comment: Created by 11150321050126 on 2016/4/30.
 */
public class QueryPointsInfoResult extends BaseResult implements Serializable {
	private static final long serialVersionUID = 6639453094898611376L;
	private String cardNo;
	private String jgId;
	private String jgType;
	private BigDecimal amount;
	private String validDate;
	private String projectCode;
	private String produceDate;
	private String transDate;
	private BigDecimal transAmount;
	private String transCard;
	private String remark;

	public String getCardNo() {
		return cardNo;
	}

	public void setCardNo(String cardNo) {
		this.cardNo = cardNo;
	}

	public String getJgId() {
		return jgId;
	}

	public void setJgId(String jgId) {
		this.jgId = jgId;
	}

	public String getJgType() {
		return jgType;
	}

	public void setJgType(String jgType) {
		this.jgType = jgType;
	}

	public BigDecimal getAmount() {
		return amount;
	}

	public void setAmount(BigDecimal amount) {
		this.amount = amount;
	}

	public String getProjectCode() {
		return projectCode;
	}

	public void setProjectCode(String projectCode) {
		this.projectCode = projectCode;
	}

	public String getValidDate() {
		return validDate;
	}

	public void setValidDate(String validDate) {
		this.validDate = validDate;
	}

	public String getProduceDate() {
		return produceDate;
	}

	public void setProduceDate(String produceDate) {
		this.produceDate = produceDate;
	}

	public String getTransDate() {
		return transDate;
	}

	public void setTransDate(String transDate) {
		this.transDate = transDate;
	}

	public BigDecimal getTransAmount() {
		return transAmount;
	}

	public void setTransAmount(BigDecimal transAmount) {
		this.transAmount = transAmount;
	}

	public String getTransCard() {
		return transCard;
	}

	public void setTransCard(String transCard) {
		this.transCard = transCard;
	}

	public String getRemark() {
		return remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}
}
