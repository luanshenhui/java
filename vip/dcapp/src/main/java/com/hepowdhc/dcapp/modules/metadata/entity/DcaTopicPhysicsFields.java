package com.hepowdhc.dcapp.modules.metadata.entity;

import com.thinkgem.jeesite.common.persistence.DataEntity;

public class DcaTopicPhysicsFields extends DataEntity<DcaTopicPhysics> {

	private static final long serialVersionUID = 1L;
	// 字段序号
	private String rowNumber;
	// 字段长度
	private String dataLength;
	// 小数位数
	private String decimalDigits;
	// 字段英文名
	private String columnName;
	// 字段中文名
	private String columnComment;
	// 字段类型
	private String columnType;
	// 字段是否为空
	private String isNull;
	// 字段是否唯一
	private String isOnly;

	// 当前表主键列表
	private String columnKey;
	// 字段默认值
	private String colDefault;

	public String getRowNumber() {
		return rowNumber;
	}

	public void setRowNumber(String rowNumber) {
		this.rowNumber = rowNumber;
	}

	public String getDataLength() {
		return dataLength;
	}

	public void setDataLength(String dataLength) {
		this.dataLength = dataLength;
	}

	public String getDecimalDigits() {
		return decimalDigits;
	}

	public void setDecimalDigits(String decimalDigits) {
		this.decimalDigits = decimalDigits;
	}

	public String getColumnName() {
		return columnName;
	}

	public void setColumnName(String columnName) {
		this.columnName = columnName;
	}

	public String getColumnComment() {
		return columnComment;
	}

	public void setColumnComment(String columnComment) {
		this.columnComment = columnComment;
	}

	public String getColumnType() {
		return columnType;
	}

	public void setColumnType(String columnType) {
		this.columnType = columnType;
	}

	public String getIsNull() {
		return isNull;
	}

	public void setIsNull(String isNull) {
		this.isNull = isNull;
	}

	public String getIsOnly() {
		return isOnly;
	}

	public void setIsOnly(String isOnly) {
		this.isOnly = isOnly;
	}

	public String getColumnKey() {
		return columnKey;
	}

	public void setColumnKey(String columnKey) {
		this.columnKey = columnKey;
	}

	public String getColDefault() {
		return colDefault;
	}

	public void setColDefault(String colDefault) {
		this.colDefault = colDefault;
	}

	/**
	 * 初始化对象的默认值：初始化"是否可空"、"是否唯一"、"是否主键"
	 */
	public void initDefaultInfo() {
		// 新建的场合，初始化"是否可空"、"是否唯一"、"是否主键"、"表名打头字母"
		this.setIsNull("1");
		this.setIsOnly("0");
		this.setColumnKey("0");

	}

}
