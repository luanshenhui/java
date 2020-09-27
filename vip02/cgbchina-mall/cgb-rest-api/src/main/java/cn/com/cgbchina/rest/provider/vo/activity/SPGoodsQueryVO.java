package cn.com.cgbchina.rest.provider.vo.activity;

import java.io.Serializable;

import javax.validation.constraints.NotNull;

import cn.com.cgbchina.rest.common.annotation.XMLNodeName;
import cn.com.cgbchina.rest.provider.vo.BaseQueryEntityVO;

/**
 * MAL335 特殊商品列表查询
 * 
 * @author lizy 2016/4/28.
 */
public class SPGoodsQueryVO extends BaseQueryEntityVO implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 6351515159570445043L;
	@NotNull
	private String origin;
	@NotNull
	private String mallType;
	@NotNull
	private String beginNo;
	@NotNull
	private String endNo;
	@NotNull
	private String queryType;
	@NotNull
	private String queryCondition;
	@XMLNodeName(value = "cust_id")
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
