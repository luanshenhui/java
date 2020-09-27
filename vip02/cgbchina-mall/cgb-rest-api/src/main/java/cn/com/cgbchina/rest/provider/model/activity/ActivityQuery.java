package cn.com.cgbchina.rest.provider.model.activity;

import cn.com.cgbchina.rest.provider.model.BaseQueryEntity;

/**
 * MAL330 场次列表查询
 * 
 * @author lizy 2016/4/28.
 */
public class ActivityQuery extends BaseQueryEntity {

	/**
	 * 
	 */
	private static final long serialVersionUID = -6822640099935849378L;
	private String origin;
	private String rowsPage;
	private String currentPage;
	private String actId;

	public String getOrigin() {
		return origin;
	}

	public void setOrigin(String origin) {
		this.origin = origin;
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

	public String getActId() {
		return actId;
	}

	public void setActId(String actId) {
		this.actId = actId;
	}

}
