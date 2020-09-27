package com.dpn.ciqqlc.standard.model;

import java.util.Date;

/**
 * 移动上传附件记录表
 * @author erikwang
 *
 */

public class VideoEventModel {
	
	/**
	 * ID
	 */
	private String id;
	/**
	 * 业务主键
	 */
	private String procMainId;
	/**
	 * 环节类型
	 */
	private String procType;
	
	/**
	 * 顶层环节类型
	 */
	private String top_proc_type;
	
	/**
	 * 文件类型 1：照片    2：视频       3：音频
	 */
	private String fileType;
	/**
	 * 文件名称
	 */
	private String fileName;
	/**
	 * 当前监管科室代码
	 */
	private String portDeptCode;
	/**
	 * 监管口岸局代码
	 */
	private String portOrgCode;
	/**
	 * 创建人
	 */
	private String createUser;
	/**
	 * 创建时间
	 */
	private Date createDate;
	/**
	 * 其他（名称）
	 */
	private String name;
	private String createStrDate;
	private String createTime;
	private boolean isCommit;
	/**
	 * 是否上传存证云Y是，N否
	 */
	private String cunnar_flag;
	
	public String getCunnar_flag() {
		return cunnar_flag;
	}
	public void setCunnar_flag(String cunnar_flag) {
		this.cunnar_flag = cunnar_flag;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getProcMainId() {
		return procMainId;
	}
	public void setProcMainId(String procMainId) {
		this.procMainId = procMainId;
	}
	public String getProcType() {
		return procType;
	}
	public void setProcType(String procType) {
		this.procType = procType;
	}
	public String getTop_proc_type() {
		return top_proc_type;
	}
	public void setTop_proc_type(String top_proc_type) {
		this.top_proc_type = top_proc_type;
	}
	public String getFileType() {
		return fileType;
	}
	public void setFileType(String fileType) {
		this.fileType = fileType;
	}
	public String getFileName() {
		return fileName;
	}
	public void setFileName(String fileName) {
		this.fileName = fileName;
	}
	public String getPortDeptCode() {
		return portDeptCode;
	}
	public void setPortDeptCode(String portDeptCode) {
		this.portDeptCode = portDeptCode;
	}
	public String getPortOrgCode() {
		return portOrgCode;
	}
	public void setPortOrgCode(String portOrgCode) {
		this.portOrgCode = portOrgCode;
	}
	public String getCreateUser() {
		return createUser;
	}
	public void setCreateUser(String createUser) {
		this.createUser = createUser;
	}
	public Date getCreateDate() {
		return createDate;
	}
	public void setCreateDate(Date createDate) {
		this.createDate = createDate;
	}
	
	private String proj_code;

	public String getProj_code() {
		return proj_code;
	}
	public void setProj_code(String proj_code) {
		this.proj_code = proj_code;
	}
	public String getCreateStrDate() {
		return createStrDate;
	}
	public void setCreateStrDate(String createStrDate) {
		this.createStrDate = createStrDate;
	}
	public String getCreateTime() {
		return createTime;
	}
	public void setCreateTime(String createTime) {
		this.createTime = createTime;
	}
	public boolean getIsCommit() {
		return isCommit;
	}
	public void setIsCommit(boolean isCommit) {
		this.isCommit = isCommit;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	
	
}
