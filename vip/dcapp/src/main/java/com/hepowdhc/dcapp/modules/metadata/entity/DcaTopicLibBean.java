/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.hepowdhc.dcapp.modules.metadata.entity;

import com.thinkgem.jeesite.common.persistence.DataEntity;

/**
 * 主题库管理Entity
 * 
 * @author 主题库管理
 * @version 2016-11-07
 */
public class DcaTopicLibBean extends DataEntity<DcaTopicLibBean> {

	private static final long serialVersionUID = 1L;
	// topic_id
	private String topicId;
	// 表名
	private String tableName;
	// 表中文名
	private String tableComment;

	public String getTopicId() {
		return topicId;
	}

	public void setTopicId(String topicId) {
		this.topicId = topicId;
	}

	public String getTableName() {
		return tableName;
	}

	public void setTableName(String tableName) {
		this.tableName = tableName;
	}

	public String getTableComment() {
		return tableComment;
	}

	public void setTableComment(String tableComment) {
		this.tableComment = tableComment;
	}

}