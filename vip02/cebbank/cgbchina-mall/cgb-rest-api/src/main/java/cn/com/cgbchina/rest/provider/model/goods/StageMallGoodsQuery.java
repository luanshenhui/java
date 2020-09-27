package cn.com.cgbchina.rest.provider.model.goods;

import java.io.Serializable;

import cn.com.cgbchina.rest.provider.model.BaseQueryEntity;

/**
 * MAL312 商品搜索列表(分期商城)
 * 
 * @author lizy 2016/4/29.
 */
public class StageMallGoodsQuery extends BaseQueryEntity implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1533834039312875999L;
	private String origin;
	private String mallType;
	private String rowsPage;
	private String currentPage;
	private String query;
	private String queryByGoodsId;
	private String querybyGoodsNm;
	private String querybyArea;
	private String querybyPoint;
	private String typePid;
	private String typeId;
	private String sequence;
	private String goodsType;
	private String querybyPointRange;
	private String custId;

	public String getOrigin() {
		return origin;
	}

	public void setOrigin(String origin) {
		this.origin = origin;
	}

	public String getMallType() {
		return mallType;
	}

	public void setMallType(String mallType) {
		this.mallType = mallType;
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

	public String getQuery() {
		return query;
	}

	public void setQuery(String query) {
		this.query = query;
	}

	public String getQueryByGoodsId() {
		return queryByGoodsId;
	}

	public void setQueryByGoodsId(String queryByGoodsId) {
		this.queryByGoodsId = queryByGoodsId;
	}

	public String getQuerybyGoodsNm() {
		return querybyGoodsNm;
	}

	public void setQuerybyGoodsNm(String querybyGoodsNm) {
		this.querybyGoodsNm = querybyGoodsNm;
	}

	public String getQuerybyArea() {
		return querybyArea;
	}

	public void setQuerybyArea(String querybyArea) {
		this.querybyArea = querybyArea;
	}

	public String getQuerybyPoint() {
		return querybyPoint;
	}

	public void setQuerybyPoint(String querybyPoint) {
		this.querybyPoint = querybyPoint;
	}

	public String getTypePid() {
		return typePid;
	}

	public void setTypePid(String typePid) {
		this.typePid = typePid;
	}

	public String getTypeId() {
		return typeId;
	}

	public void setTypeId(String typeId) {
		this.typeId = typeId;
	}

	public String getSequence() {
		return sequence;
	}

	public void setSequence(String sequence) {
		this.sequence = sequence;
	}

	public String getGoodsType() {
		return goodsType;
	}

	public void setGoodsType(String goodsType) {
		this.goodsType = goodsType;
	}

	public String getQuerybyPointRange() {
		return querybyPointRange;
	}

	public void setQuerybyPointRange(String querybyPointRange) {
		this.querybyPointRange = querybyPointRange;
	}

	public String getCustId() {
		return custId;
	}

	public void setCustId(String custId) {
		this.custId = custId;
	}

}
