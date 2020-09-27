package cn.com.cgbchina.rest.provider.vo.activity;

import javax.validation.constraints.NotNull;

import cn.com.cgbchina.rest.common.annotation.XMLNodeName;
import cn.com.cgbchina.rest.provider.vo.BaseQueryEntityVO;

/**
 * MAL330 场次列表查询
 * 
 * @author lizy 2016/4/28.
 */
public class ActivityQueryVO extends BaseQueryEntityVO {

	/**
	 * 
	 */
	private static final long serialVersionUID = -6822640099935849378L;
	@NotNull
	private String origin;
	@NotNull
	private String rowsPage;
	@NotNull
	private String currentPage;
	@XMLNodeName(value = "act_id")
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
