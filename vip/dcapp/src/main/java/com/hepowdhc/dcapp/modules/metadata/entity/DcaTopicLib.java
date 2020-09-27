/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.hepowdhc.dcapp.modules.metadata.entity;

import java.util.List;

import org.hibernate.validator.constraints.Length;

import com.google.common.collect.Lists;
import com.thinkgem.jeesite.common.persistence.DataEntity;

/**
 * 主题库管理Entity
 * 
 * @author 主题库管理
 * @version 2016-11-07
 */
public class DcaTopicLib extends DataEntity<DcaTopicLib> {

	private static final long serialVersionUID = 1L;
	// topic_id
	private String topicId;
	// topic_name
	private String topicName;
	// is_show
	private String isShow;
	// create_person
	private String createPerson;
	// update_person
	private String updatePerson;
	// 表名
	private String tableName;
	// 表中文名
	private String tableComment;
	// checkbox表列
	private String phyCheck;
	// tableNameList 表列
	private List<DcaTopicLib> tableNameList = Lists.newArrayList();
	// 页面弹出提醒标志位
	private int pageFlag;

	// remarks
	private String remarks;
	// slist
	private String saveList;
	// dlist
	private String delList;

	// changeFlag
	private String changeFlag;

	// 判断 主题库的状态
	private String topicStatus;

	public String getTopicStatus() {
		return topicStatus;
	}

	public void setTopicStatus(String topicStatus) {
		this.topicStatus = topicStatus;
	}

	public String getChangeFlag() {
		return changeFlag;
	}

	public void setChangeFlag(String changeFlag) {
		this.changeFlag = changeFlag;
	}

	public String getSaveList() {
		return saveList;
	}

	public void setSaveList(String saveList) {
		this.saveList = saveList;
	}

	public String getDelList() {
		return delList;
	}

	public void setDelList(String delList) {
		this.delList = delList;
	}

	@Length(min = 0, max = 60, message = "remarks长度必须介于0 和 60 之间")
	public String getRemarks() {
		return remarks;
	}

	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}

	public int getPageFlag() {
		return pageFlag;
	}

	public void setPageFlag(int pageFlag) {
		this.pageFlag = pageFlag;
	}

	public List<DcaTopicLib> getTableNameList() {
		return tableNameList;
	}

	public void setTableNameList(List<DcaTopicLib> tableNameList) {
		this.tableNameList = tableNameList;
	}

	public String getPhyCheck() {
		return phyCheck;
	}

	public void setPhyCheck(String phyCheck) {
		this.phyCheck = phyCheck;
	}

	public String getTableComment() {
		return tableComment;
	}

	public void setTableComment(String tableComment) {
		this.tableComment = tableComment;
	}

	public String getTableName() {
		return tableName;
	}

	public void setTableName(String tableName) {
		this.tableName = tableName;
	}

	public DcaTopicLib() {
		super();
	}

	public DcaTopicLib(String id) {
		super(id);
	}

	@Length(min = 1, max = 50, message = "topic_id长度必须介于 1 和 50 之间")
	public String getTopicId() {
		return topicId;
	}

	public void setTopicId(String topicId) {
		this.topicId = topicId;
	}

	@Length(min = 1, max = 30, message = "topic_name长度必须介于 1 和 30 之间")
	public String getTopicName() {
		return topicName;
	}

	public void setTopicName(String topicName) {
		this.topicName = topicName;
	}

	@Length(min = 0, max = 2, message = "is_show长度必须介于 0 和 2 之间")
	public String getIsShow() {
		return isShow;
	}

	public void setIsShow(String isShow) {
		this.isShow = isShow;
	}

	@Length(min = 0, max = 64, message = "create_person长度必须介于 0 和 64 之间")
	public String getCreatePerson() {
		return createPerson;
	}

	public void setCreatePerson(String createPerson) {
		this.createPerson = createPerson;
	}

	@Length(min = 0, max = 64, message = "update_person长度必须介于 0 和 64 之间")
	public String getUpdatePerson() {
		return updatePerson;
	}

	public void setUpdatePerson(String updatePerson) {
		this.updatePerson = updatePerson;
	}

}