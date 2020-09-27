package cn.com.cgbchina.rest.provider.model.order;

import java.io.Serializable;

import cn.com.cgbchina.rest.provider.model.BaseQueryEntity;

public class VerificationCodeQuery extends BaseQueryEntity implements Serializable {

	private static final long serialVersionUID = 7671813941741235495L;
	/**
	 * 
	 */
	private String origin;
	private String beginDate;
	private String endDate;
	private String vendorNm;
	private String goodsNm;
	private String createOper;
	private String rowsPage;
	private String currentPage;

	public String getOrigin() {
		return origin;
	}

	public void setOrigin(String origin) {
		this.origin = origin;
	}

	public String getBeginDate() {
		return beginDate;
	}

	public void setBeginDate(String beginDate) {
		this.beginDate = beginDate;
	}

	public String getEndDate() {
		return endDate;
	}

	public void setEndDate(String endDate) {
		this.endDate = endDate;
	}

	public String getVendorNm() {
		return vendorNm;
	}

	public void setVendorNm(String vendorNm) {
		this.vendorNm = vendorNm;
	}

	public String getGoodsNm() {
		return goodsNm;
	}

	public void setGoodsNm(String goodsNm) {
		this.goodsNm = goodsNm;
	}

	public String getCreateOper() {
		return createOper;
	}

	public void setCreateOper(String createOper) {
		this.createOper = createOper;
	}

	public String getRowsPage() {
		return rowsPage;
	}

	public void setRowsPage(String rowsPage) {
		this.rowsPage = rowsPage;
	}

	public String getCurrentPage() {
		return currentPage;
	}

	public void setCurrentPage(String currentPage) {
		this.currentPage = currentPage;
	}

}
