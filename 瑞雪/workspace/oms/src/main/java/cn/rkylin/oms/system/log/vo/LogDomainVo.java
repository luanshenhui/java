package cn.rkylin.oms.system.log.vo;

import org.apache.commons.lang.StringUtils;

import cn.rkylin.oms.system.log.domain.LogDomain;

public class LogDomainVo extends LogDomain{

	/**
	 * 序列号
	 */
	private static final long serialVersionUID = -7125875100802744681L;
	private static final String STATUS_CHK = "<input name=\"chkItem\" type=\"checkbox\" bizid=\"%s\"/></input>";
	private static final String OPERATION_BTN_VIEW = "<button onclick=\"view(\'%s\',this)\" type=\"button\" class=\"btn btn-info btn-xs\"><i class=\"fa fa fa-edit\"></i>&nbsp;查看</button>";
	private String chkBox;
	/**
	 * orderBy子句
	 */
	private String orderBy;
	private String operationButton;
	/**
	 * 搜索条件
	 */
	private String searchCondition;


	public String getOrderBy() {
		return orderBy;
	}

	public void setOrderBy(String orderBy) {
		this.orderBy = orderBy;
	}

	public String getSearchCondition() {
		return searchCondition;
	}

	public void setSearchCondition(String searchCondition) {
		this.searchCondition = searchCondition;
	}

	public String getOperationButton() {
		return operationButton;
	}

	public void setOperationButton(String operationButton) {
		StringBuffer opButton = new StringBuffer();
		if (StringUtils.isNotEmpty(getBizId())) {
			opButton.append(String.format(OPERATION_BTN_VIEW, getBizId()));
			opButton.append("&nbsp;");
		}
		this.operationButton = opButton.toString();
	}

	public String getChkBox() {
		return chkBox;
	}

	public void setChkBox(String chkBox) {
		this.chkBox = String.format(STATUS_CHK, getBizId()).toString();
	}
	
	
}
