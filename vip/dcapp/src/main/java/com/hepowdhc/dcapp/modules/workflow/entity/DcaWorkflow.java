/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.hepowdhc.dcapp.modules.workflow.entity;

import java.util.Date;

import org.hibernate.validator.constraints.Length;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.thinkgem.jeesite.common.persistence.DataEntity;

/**
 * 工作流管理Entity
 * 
 * @author shiqiang.zhang
 * @version 2016-11-21
 */
/**
 * @author 11150321050086
 *
 */
public class DcaWorkflow extends DataEntity<DcaWorkflow> {

	private static final long serialVersionUID = 1L;
	private int num;
	private String wfId; // 序号
	private String wfName; // 工作流名称
	private String powerId; // 权力
	private String xmlName; // XML文件名称
	private String xmlContent; // XML文件存储
	private Date startTime; // 开始时间
	private Date endTime; // 结束时间
	private String wfLevel; // 优先级
	private String idxDataType; // 数据分类
	private String createPerson; // 创建人
	private String updatePerson; // 更新者
	private String isShow;
	private String idxDataTypeName;
	private String remarks;
	private String editEnable;
	private String traceDictId; // 模板ID

	@Length(min = 0, max = 66, message = "说明长度必须介于 0 和 66 之间")
	public String getRemarks() {
		return remarks;
	}

	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}

	public DcaWorkflow() {
		super();
	}

	public DcaWorkflow(String id) {
		super(id);
	}

	public int getNum() {
		return num;
	}

	public void setNum(int num) {
		this.num = num;
	}

	@Length(min = 1, max = 50, message = "序号长度必须介于 1 和 50 之间")
	public String getWfId() {
		return wfId;
	}

	public void setWfId(String wfId) {
		this.wfId = wfId;
	}

	@Length(min = 1, max = 80, message = "工作流名称长度必须介于 1 和 80 之间")
	public String getWfName() {
		return wfName;
	}

	public void setWfName(String wfName) {
		this.wfName = wfName;
	}

	@Length(min = 1, max = 50, message = "权力长度必须介于 1 和 50 之间")
	public String getPowerId() {
		return powerId;
	}

	public void setPowerId(String powerId) {
		this.powerId = powerId;
	}

	@Length(min = 0, max = 50, message = "XML文件名称长度必须介于 0 和 50 之间")
	public String getXmlName() {
		return xmlName;
	}

	public void setXmlName(String xmlName) {
		this.xmlName = xmlName;
	}

	public String getXmlContent() {
		return xmlContent;
	}

	public void setXmlContent(String xmlContent) {
		this.xmlContent = xmlContent;
	}

	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	public Date getStartTime() {
		return startTime;
	}

	public void setStartTime(Date startTime) {
		this.startTime = startTime;
	}

	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	public Date getEndTime() {
		return endTime;
	}

	public void setEndTime(Date endTime) {
		this.endTime = endTime;
	}

	@Length(min = 1, max = 5, message = "优先级长度必须介于 1 和 5 之间")
	public String getWfLevel() {
		return wfLevel;
	}

	public void setWfLevel(String wfLevel) {
		this.wfLevel = wfLevel;
	}

	public String getIdxDataType() {
		return idxDataType;
	}

	public void setIdxDataType(String idxDataType) {
		this.idxDataType = idxDataType;
	}

	@Length(min = 0, max = 64, message = "创建人长度必须介于 0 和 64 之间")
	public String getCreatePerson() {
		return createPerson;
	}

	public void setCreatePerson(String createPerson) {
		this.createPerson = createPerson;
	}

	@Length(min = 0, max = 64, message = "更新者长度必须介于 0 和 64 之间")
	public String getUpdatePerson() {
		return updatePerson;
	}

	public void setUpdatePerson(String updatePerson) {
		this.updatePerson = updatePerson;
	}

	public String getIsShow() {
		return isShow;
	}

	public void setIsShow(String isShow) {
		this.isShow = isShow;
	}

	public String getIdxDataTypeName() {
		return idxDataTypeName;
	}

	public void setIdxDataTypeName(String idxDataTypeName) {
		this.idxDataTypeName = idxDataTypeName;
	}

	public String getEditEnable() {
		return editEnable;
	}

	public void setEditEnable(String editEnable) {
		this.editEnable = editEnable;
	}

	@Length(min = 0, max = 30, message = "模板ID长度必须介于 1和 30 之间")
	public String getTraceDictId() {
		return traceDictId;
	}

	public void setTraceDictId(String traceDictId) {
		this.traceDictId = traceDictId;
	}

}