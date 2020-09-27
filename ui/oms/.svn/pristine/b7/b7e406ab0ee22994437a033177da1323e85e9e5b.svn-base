package cn.rkylin.oms.system.splitRule.vo;

import org.apache.commons.lang.StringUtils;

import cn.rkylin.oms.system.splitRule.domain.SplitRule;

public class SplitRuleVO extends SplitRule{

	/**
	 * 
	 */
	private static final long serialVersionUID = -4368183511743910005L;

	/**
	 * 搜索条件
	 */
	private String searchCondition;

	/**
	 * 状态定义
	 */
	private static final String STATUS_YES = "<span>%s</span>";
	private static final String STATUS_NO = "<span style=\"color:red\">%s</span>";
	
	/*
	 * 列表操作按钮定义
	 */
	private static final String OPERATION_RULE_SELECT = "<input type=\"checkbox\" disabled/>";
	private static final String OPERATION_BTN_SETITEM = "<button onclick=\"operationSetItem(\'%s\',\'%s\',\'%s\',\'%s\',this)\" shoptype=\"%s\" projectname=\"%s\" shopname=\"%s\" type=\"button\" class=\"btn btn-info btn-xs\"><i class=\"fa fa-edit\"></i>&nbsp;设置详情</button>";
	private static final String OPERATION_BTN_ENABLE = "<button onclick=\"showEnableConfirm(\'%s\',\'%s\',\'n\',\'%s\',this)\" type=\"button\" class=\"btn btn-success btn-xs\"><i class=\"fa fa-check\"></i>&nbsp;启用</button>";
	private static final String OPERATION_BTN_ENABLE_DISABLED = "<button onclick=\"showEnableConfirm(\'%s\',\'%s\',\'n\',\'%s\',this)\" type=\"button\" class=\"btn btn-warning btn-xs\"><i class=\"fa fa-ban\"></i>&nbsp;停用</button>";
	
	/**
	 * 其他的SQL
	 */
	private String otherSql;
	/**
	 * orderBy子句
	 */
	private String orderBy;
	/**
	 * 项目名称
	 */
	private String prjName;
	/**
	 * 项目名称
	 */
	private String prjId;
	/**
	 * 启用状态
	 */
	private String status;
	/**
	 * 操作
	 */
	private String operation;
	private String ecItemId;
	private String ecItemCode;
	private String ecItemName;
	private String outerCode;
	private String splitShopName;
	
	private String ruleSelect;

	public String getRuleSelect() {
		return ruleSelect;
	}

	public void setRuleSelect(String ruleSelect) {
		this.ruleSelect = OPERATION_RULE_SELECT;
	}
	public String getSearchCondition() {
		return searchCondition;
	}

	public void setSearchCondition(String searchCondition) {
		this.searchCondition = searchCondition;
	}

	public String getOrderBy() {
		return orderBy;
	}

	public void setOrderBy(String orderBy) {
		this.orderBy = orderBy;
	}

	public String getPrjName() {
		return prjName;
	}

	public void setPrjName(String prjName) {
		this.prjName = prjName;
	}

	public String getStatus() {
		return status;
	}

	/**
	 * 设置列表上的状态列label
	 * @param status
	 */
	public void setStatus(String status) {
		StringBuffer statusButton = new StringBuffer();
		if (this.getEnable().equalsIgnoreCase("y")) {
			statusButton.append(String.format(STATUS_YES, "启用"));
		} else {
			statusButton.append(String.format(STATUS_NO, "禁用"));
		}
		this.status = statusButton.toString();
	}

	public String getOperation() {
		return operation;
	}

	public void setOperation(String operation) {
		StringBuffer opButton = new StringBuffer();
		if (StringUtils.isNotEmpty(getSplitRuleId())) {
			opButton.append(String.format(OPERATION_BTN_SETITEM, getShopId(),getSplitRuleId(),getEnable(),getUpdateTime().toString(),getShopType(),getPrjName(),getShopName()));
			opButton.append("&nbsp;");
			if (this.getEnable().equalsIgnoreCase("y")) {
				opButton.append(String.format(OPERATION_BTN_ENABLE_DISABLED, getSplitRuleId(),getEnable(),getUpdateTime().toString()));
				opButton.append("&nbsp;");
			} else {
				opButton.append(String.format(OPERATION_BTN_ENABLE, getSplitRuleId(),getEnable(),getUpdateTime().toString()));
				opButton.append("&nbsp;");
			}
		}
		this.operation = opButton.toString();
	}

	public String getPrjId() {
		return prjId;
	}

	public void setPrjId(String prjId) {
		this.prjId = prjId;
	}

	public String getOtherSql() {
		return otherSql;
	}

	public void setOtherSql(String otherSql) {
		this.otherSql = otherSql;
	}

	public String getEcItemId() {
		return ecItemId;
	}

	public void setEcItemId(String ecItemId) {
		this.ecItemId = ecItemId;
	}

	public String getEcItemCode() {
		return ecItemCode;
	}

	public void setEcItemCode(String ecItemCode) {
		this.ecItemCode = ecItemCode;
	}

	public String getEcItemName() {
		return ecItemName;
	}

	public void setEcItemName(String ecItemName) {
		this.ecItemName = ecItemName;
	}

	public String getOuterCode() {
		return outerCode;
	}

	public void setOuterCode(String outerCode) {
		this.outerCode = outerCode;
	}

	public String getSplitShopName() {
		return splitShopName;
	}

	public void setSplitShopName(String splitShopName) {
		this.splitShopName = splitShopName;
	}
}
