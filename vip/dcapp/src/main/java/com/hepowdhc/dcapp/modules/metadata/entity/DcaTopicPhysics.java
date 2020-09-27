/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.hepowdhc.dcapp.modules.metadata.entity;

import java.util.List;

import org.hibernate.validator.constraints.Length;

import com.google.common.collect.Lists;
import com.thinkgem.jeesite.common.persistence.DataEntity;

/**
 * DcaTopicPhysicsEntity
 * 
 * @author hunan
 * @version 2016-11-08
 */
public class DcaTopicPhysics extends DataEntity<DcaTopicPhysics> {

	private static final long serialVersionUID = 1L;

	// 物理表英文名
	private String tableName;

	// 物理表英文名
	private String oldTableName;

	// 物理表中文名
	private String tableComment;

	//主题库id
	private String topicId;

	//主题库名称
	private String topicName;

	private DcaTopicPhysicsFields currentFiled = new DcaTopicPhysicsFields();
	// 表列
	private List<DcaTopicPhysicsFields> columnList = Lists.newArrayList();

	// 数据库类型
	private String dbType;

	// 数据类型
	private String typeValue;

	public DcaTopicPhysics() {
		super();
	}

	public DcaTopicPhysics(String tableName) {
		super(tableName);
	}

	// 定义变量的getting和setting
	@Length(min = 1, max = 25, message = "tableName长度必须介于 1 和 25之间")
	public String getTableName() {
		return tableName;
	}

	public void setTableName(String tableName) {
		this.tableName = tableName;
	}

	public String getOldTableName() {
		return oldTableName;
	}

	public void setOldTableName(String oldTableName) {
		this.oldTableName = oldTableName;
	}

	@Length(min = 0, max = 50, message = "tableComment长度必须介于 0 和 25 之间")
	public String getTableComment() {
		return tableComment;
	}

	public void setTableComment(String tableComment) {
		this.tableComment = tableComment;
	}

	public DcaTopicPhysicsFields getCurrentFiled() {
		return currentFiled;
	}

	public void setCurrentFiled(DcaTopicPhysicsFields currentFiled) {
		this.currentFiled = currentFiled;
	}

	public List<DcaTopicPhysicsFields> getColumnList() {
		return columnList;
	}

	public void setColumnList(List<DcaTopicPhysicsFields> columnList) {
		this.columnList = columnList;
	}

	public String getDbType() {
		return dbType;
	}

	public void setDbType(String dbType) {
		this.dbType = dbType;
	}

	public String getTypeValue() {
		return typeValue;
	}

	public void setTypeValue(String dataType) {
		this.typeValue = dataType;
	}

	public String getTopicId() {
		return topicId;
	}

	public void setTopicId(String topicId) {
		this.topicId = topicId;
	}

	public String getTopicName() {
		return topicName;
	}

	public void setTopicName(String topicName) {
		this.topicName = topicName;
	}
}