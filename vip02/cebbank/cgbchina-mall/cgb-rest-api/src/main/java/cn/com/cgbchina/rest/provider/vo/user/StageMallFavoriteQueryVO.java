package cn.com.cgbchina.rest.provider.vo.user;

import java.io.Serializable;

import javax.validation.constraints.NotNull;

import cn.com.cgbchina.rest.common.annotation.XMLNodeName;
import cn.com.cgbchina.rest.provider.vo.BaseQueryEntityVO;

/**
 * MAL302 查询收藏商品(分期商城) 查询对象
 * 
 * @author lizy 2016/4/28.
 */
public class StageMallFavoriteQueryVO extends BaseQueryEntityVO implements Serializable {
	private static final long serialVersionUID = -2028716554818238998L;
	@NotNull
	private String origin;
	@XMLNodeName(value = "cust_id")
	private String custId;
	@NotNull
	private String rowsPage;
	@NotNull
	private String currentPage;

	public String getOrigin() {
		return origin;
	}

	public void setOrigin(String origin) {
		this.origin = origin;
	}

	public String getCustId() {
		return custId;
	}

	public void setCustId(String custId) {
		this.custId = custId;
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
