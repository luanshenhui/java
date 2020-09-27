package cn.com.cgbchina.rest.visit.model.point;

import java.io.Serializable;
import java.math.BigDecimal;

import cn.com.cgbchina.rest.visit.model.BaseResult;

/**
 * Comment: Created by 11150321050126 on 2016/4/30.
 */
public class QueryPointsInfoResult implements Serializable {
	private static final long serialVersionUID = 6639453094898611376L;
	private String cardNo;
	private String cardEnd;
	private String jgId;
	private String jgtype;
	private BigDecimal account;
	private String status;
	private String validDate;
	private String custSummary;
	private String productCode;
	private String cardDesc;
	private String cfprCode;
	private String prodCode;
	private String promotionPgm;
	private String levelCode;

	public String getCardNo() {
		return cardNo;
	}

	public void setCardNo(String cardNo) {
		this.cardNo = cardNo;
	}

	public String getCardEnd() {
		return cardEnd;
	}

	public void setCardEnd(String cardEnd) {
		this.cardEnd = cardEnd;
	}

	public String getJgId() {
		return jgId;
	}

	public void setJgId(String jgId) {
		this.jgId = jgId;
	}

	public String getJgtype() {
		return jgtype;
	}

	public void setJgtype(String jgtype) {
		this.jgtype = jgtype;
	}

	public BigDecimal getAccount() {
		return account;
	}

	public void setAccount(BigDecimal account) {
		this.account = account;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getValidDate() {
		return validDate;
	}

	public void setValidDate(String validDate) {
		this.validDate = validDate;
	}

	public String getCustSummary() {
		return custSummary;
	}

	public void setCustSummary(String custSummary) {
		this.custSummary = custSummary;
	}

	public String getProductCode() {
		return productCode;
	}

	public void setProductCode(String productCode) {
		this.productCode = productCode;
	}

	public String getCardDesc() {
		return cardDesc;
	}

	public void setCardDesc(String cardDesc) {
		this.cardDesc = cardDesc;
	}

	public String getCfprCode() {
		return cfprCode;
	}

	public void setCfprCode(String cfprCode) {
		this.cfprCode = cfprCode;
	}

	public String getProdCode() {
		return prodCode;
	}

	public void setProdCode(String prodCode) {
		this.prodCode = prodCode;
	}

	public String getPromotionPgm() {
		return promotionPgm;
	}

	public void setPromotionPgm(String promotionPgm) {
		this.promotionPgm = promotionPgm;
	}

	public String getLevelCode() {
		return levelCode;
	}

	public void setLevelCode(String levelCode) {
		this.levelCode = levelCode;
	}

}
