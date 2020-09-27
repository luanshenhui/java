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
	private String origin;//请求来源
	private String mallType;//商城类型  分期商城:01 积分商城02
	private String rowsPage;// limit
	private String currentPage;// 请求页数
	private String query;// 商品搜索条件
	private String queryByGoodsId;// goods_id
	private String querybyGoodsNm;// goods_name
	private String querybyArea;// 分区代码
	private String querybyPoint;// 积分段搜索
	private String typePid;// 类型父id 对应后台二级类目
	private String typeId;// 类型id 对应后后台三级类目
	private String sequence;// 排序
	private String goodsType;// 商品类型
	private String querybyPointRange;// 可输入积分段搜索
	private String custId;// 客户号

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
