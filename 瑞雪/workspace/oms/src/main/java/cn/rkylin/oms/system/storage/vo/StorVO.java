package cn.rkylin.oms.system.storage.vo;

import cn.rkylin.oms.system.storage.domain.OMS_STOR;

public class StorVO extends OMS_STOR {
	private static final String STATUS_CHK = "<input id=\"chkItem\" name=\"chkItem\" type=\"checkbox\" storid=\"%s\" /></input>";
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
	* checkbox
	*/
	private String chk;

	/**
	* 更改前仓库名称
	*/
	private String updateStorName;
	
	/**
	* 更改前仓库编码
	*/
	private String updateStorCode;
	
	public String getUpdateStorCode() {
		return updateStorCode;
	}
	public void setUpdateStorCode(String updateStorCode) {
		this.updateStorCode = updateStorCode;
	}
	public String getUpdateStorName() {
		return updateStorName;
	}
	public void setUpdateStorName(String updateStorName) {
		this.updateStorName = updateStorName;
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
		this.chk = String.format(STATUS_CHK, this.getStorId()).toString();
	}
//	public String getDeleted() {
//		return deleted;
//	}
//	public void setDeleted(String deleted) {
//		this.deleted = deleted;
//	}
//	public String getCreate_time() {
//		return create_time;
//	}
//	public void setCreate_time(String create_time) {
//		this.create_time = create_time;
//	}
//	public String getModify_time() {
//		return modify_time;
//	}
//	public void setModify_time(String modify_time) {
//		this.modify_time = modify_time;
//	}
}
