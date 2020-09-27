package cn.rkylin.oms.system.role.vo;

import cn.rkylin.oms.system.role.domain.WF_ORG_ROLE;

public class RoleVo extends WF_ORG_ROLE {
	private static final String STATUS_CHK = "<input id=\"chkItem\" name=\"chkItem\" type=\"checkbox\" roleid=\"%s\" /></input>";
	private static final String STATUS_RADIO = "<input id=\"statusRadio\" name=\"statusRadio\" type=\"radio\" radioId=\"%s\" /></input>";
	
	/**
	* 序列
	*/
	private static final long serialVersionUID = 7261100665980740680L;
	
	/**
	* orderBy子句
	*/
	private String orderBy;
	
	/**
	* 搜索条件
	*/
	private String searchCondition;
	
	/**
	* 组织单元id
	*/
	private String txtRoleUnitsValue;
	
	/**
	* 包含人员
	*/
	private String txtRoleUsers;
	
	/**
	* 组织单元
	*/
	private String txtRoleUnits;
	
	/**
	* checkbox
	*/
	private String chk;
	
	/**
	* radio
	*/
	private String radio;
	
	public String getTxtRoleUnitsValue() {
		return txtRoleUnitsValue;
	}
	public void setTxtRoleUnitsValue(String txtRoleUnitsValue) {
		this.txtRoleUnitsValue = txtRoleUnitsValue;
	}
	public String getTxtRoleUsers() {
		return txtRoleUsers;
	}
	public String getTxtRoleUnits() {
		return txtRoleUnits;
	}
	public void setTxtRoleUsers(String txtRoleUsers) {
		this.txtRoleUsers = txtRoleUsers;
	}
	public void setTxtRoleUnits(String txtRoleUnits) {
		this.txtRoleUnits = txtRoleUnits;
	}
	
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
	
	public String getChk() {
		return this.chk;
	}
	
	public void setChk(String chk) {
		this.chk = String.format(STATUS_CHK, this.getRoleId()).toString();
	}
	
	public String getRadio() {
		return radio;
	}
	
	public void setRadio(String radio) {
		this.radio = String.format(STATUS_RADIO, this.getRoleId()).toString();
	}
	
	
}
