package com.hepowdhc.dcapp.modules.visualization.entity;

import org.hibernate.validator.constraints.Length;

import com.thinkgem.jeesite.common.persistence.DataEntity;

public class DcaReportRiskEntity extends DataEntity<DcaReportRiskEntity> {

	private static final long serialVersionUID = 1L;

	/**
	 * 业务事项id
	 */
	private String flowID;

	/**
	 * 业务事项名
	 */
	private String flowName;

	/**
	 * 办理事项id
	 */
	private String dataId;

	/**
	 * 办理事项名
	 */
	private String dataName;

	/**
	 * 风险（黄色）记录数
	 */
	private Integer yellowCount;

	/**
	 * 风险（橙色）记录数
	 */
	private Integer orangeCount;

	/**
	 * 风险（红色）记录数
	 */
	private Integer redCount;

	private Integer totalCount;

	private String bizOperPerson; // 业务操作人
	private String bizOperPost; // 业务操作人所属部门

	/**
	 * 业务类型（三重一大、投资、担保）
     */
	private String idxDataType;
	public String getIdxDataType() {
		return idxDataType;
	}

	public void setIdxDataType(String idxDataType) {
		this.idxDataType = idxDataType;
	}

	/**
	 * 部门id
	 */
	private String postId;

	public String getPostId() {
		return postId;
	}

	public void setPostId(String postId) {
		this.postId = postId;
	}

	// 年份
	private Integer year;

	public String getFlowID() {
		return flowID;
	}

	public void setFlowID(String flowID) {
		this.flowID = flowID;
	}

	public String getFlowName() {
		return flowName;
	}

	public void setFlowName(String flowName) {
		this.flowName = flowName;
	}

	public String getDataId() {
		return dataId;
	}

	public void setDataId(String dataId) {
		this.dataId = dataId;
	}

	public String getDataName() {
		return dataName;
	}

	public void setDataName(String dataName) {
		this.dataName = dataName;
	}

	public Integer getYellowCount() {
		return yellowCount;
	}

	public void setYellowCount(Integer yellowCount) {
		this.yellowCount = yellowCount;
	}

	public Integer getRedCount() {
		return redCount;
	}

	public void setRedCount(Integer redCount) {
		this.redCount = redCount;
	}

	@Length(min = 0, max = 50, message = "业务操作人长度必须介于 0 和 50 之间")
	public String getBizOperPerson() {
		return bizOperPerson;
	}

	public void setBizOperPerson(String bizOperPerson) {
		this.bizOperPerson = bizOperPerson;
	}

	@Length(min = 0, max = 100, message = "业务操作人所属部门长度必须介于 0 和 100 之间")
	public String getBizOperPost() {
		return bizOperPost;
	}

	public void setBizOperPost(String bizOperPost) {
		this.bizOperPost = bizOperPost;
	}

	public Integer getTotalCount() {
		return totalCount;
	}

	public void setTotalCount(Integer totalCount) {
		this.totalCount = totalCount;
	}

	public Integer getYear() {
		return year;
	}

	public void setYear(Integer year) {
		this.year = year;
	}

	public Integer getOrangeCount() {
		return orangeCount;
	}

	public void setOrangeCount(Integer orangeCount) {
		this.orangeCount = orangeCount;
	}

}
