package cn.com.cgbchina.rest.provider.model.activity;

import java.io.Serializable;

import cn.com.cgbchina.rest.provider.model.BaseQueryEntity;

/**
 * MAL335 特殊商品列表查询
 * 
 * @author lizy 2016/4/28.
 */
public class SPGoodsQuery extends BaseQueryEntity implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 6351515159570445043L;
	private String origin;
	private String mallType;
	private String beginNo;
	private String endNo;
	private String queryType;
	private String queryCondition;
	private String custId;
	private String sequence;

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

	public String getBeginNo() {
		return beginNo;
	}

	public void setBeginNo(String beginNo) {
		this.beginNo = beginNo;
	}

	public String getEndNo() {
		return endNo;
	}

	public void setEndNo(String endNo) {
		this.endNo = endNo;
	}

	public String getQueryType() {
		return queryType;
	}

	public void setQueryType(String queryType) {
		this.queryType = queryType;
	}

	public String getQueryCondition() {
		return queryCondition;
	}

	public void setQueryCondition(String queryCondition) {
		this.queryCondition = queryCondition;
	}

	public String getCustId() {
		return custId;
	}

	public void setCustId(String custId) {
		this.custId = custId;
	}

	public String getSequence() {
		return sequence;
	}

	public void setSequence(String sequence) {
		this.sequence = sequence;
	}

}
