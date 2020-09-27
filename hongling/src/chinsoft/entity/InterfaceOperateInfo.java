package chinsoft.entity;

import java.util.Date;

/**
 * InterfaceOperateInfo entity. @author MyEclipse Persistence Tools
 */

public class InterfaceOperateInfo implements java.io.Serializable {

	// Fields

	private Long id;
	private Date startTime;
	private Date endTime;
	private Long workflowId;
	private Long userId;
	private Byte serviceFlag;
	private Byte workflowFlag;
	private Byte dealFlag;
	private Byte operateType;
	private Long itemCount;
	private Long operateItemNum;
	private String failedInfo;
	private String remark;

	// Constructors

	/** default constructor */
	public InterfaceOperateInfo() {
	}

	/** minimal constructor */
	public InterfaceOperateInfo(Date startTime, Long workflowId, Long userId,
			Byte serviceFlag, Byte workflowFlag, Byte dealFlag, Byte operateType) {
		this.startTime = startTime;
		this.workflowId = workflowId;
		this.userId = userId;
		this.serviceFlag = serviceFlag;
		this.workflowFlag = workflowFlag;
		this.dealFlag = dealFlag;
		this.operateType = operateType;
	}

	/** full constructor */
	public InterfaceOperateInfo(Date startTime, Date endTime, Long workflowId,
			Long userId, Byte serviceFlag, Byte workflowFlag, Byte dealFlag,
			Byte operateType, Long itemCount, Long operateItemNum,
			String failedInfo, String remark) {
		this.startTime = startTime;
		this.endTime = endTime;
		this.workflowId = workflowId;
		this.userId = userId;
		this.serviceFlag = serviceFlag;
		this.workflowFlag = workflowFlag;
		this.dealFlag = dealFlag;
		this.operateType = operateType;
		this.itemCount = itemCount;
		this.operateItemNum = operateItemNum;
		this.failedInfo = failedInfo;
		this.remark = remark;
	}

	// Property accessors

	public Long getId() {
		return this.id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Date getStartTime() {
		return this.startTime;
	}

	public void setStartTime(Date startTime) {
		this.startTime = startTime;
	}

	public Date getEndTime() {
		return this.endTime;
	}

	public void setEndTime(Date endTime) {
		this.endTime = endTime;
	}

	public Long getWorkflowId() {
		return this.workflowId;
	}

	public void setWorkflowId(Long workflowId) {
		this.workflowId = workflowId;
	}

	public Long getUserId() {
		return this.userId;
	}

	public void setUserId(Long userId) {
		this.userId = userId;
	}

	public Byte getServiceFlag() {
		return this.serviceFlag;
	}

	public void setServiceFlag(Byte serviceFlag) {
		this.serviceFlag = serviceFlag;
	}

	public Byte getWorkflowFlag() {
		return this.workflowFlag;
	}

	public void setWorkflowFlag(Byte workflowFlag) {
		this.workflowFlag = workflowFlag;
	}

	public Byte getDealFlag() {
		return this.dealFlag;
	}

	public void setDealFlag(Byte dealFlag) {
		this.dealFlag = dealFlag;
	}

	public Byte getOperateType() {
		return this.operateType;
	}

	public void setOperateType(Byte operateType) {
		this.operateType = operateType;
	}

	public Long getItemCount() {
		return this.itemCount;
	}

	public void setItemCount(Long itemCount) {
		this.itemCount = itemCount;
	}

	public Long getOperateItemNum() {
		return this.operateItemNum;
	}

	public void setOperateItemNum(Long operateItemNum) {
		this.operateItemNum = operateItemNum;
	}

	public String getFailedInfo() {
		return this.failedInfo;
	}

	public void setFailedInfo(String failedInfo) {
		this.failedInfo = failedInfo;
	}

	public String getRemark() {
		return this.remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}

}