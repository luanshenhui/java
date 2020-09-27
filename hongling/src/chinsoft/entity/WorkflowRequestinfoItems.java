package chinsoft.entity;

import java.util.Date;

/**
 * WorkflowRequestinfoItems entity. @author MyEclipse Persistence Tools
 */

public class WorkflowRequestinfoItems implements java.io.Serializable {

	// Fields

	private Long id;
	private String creatorId;
	private String memberId;
	private Long interfaceId;
	private Byte cashFlag;
	private Double total;
	private Date workflowTime;
	private Byte flowFlag;
	private Long requestId;
	private String requestInfo;
	private Long userId;
	private Long itemId;
	private Long workflowId;
	private String remark;

	// Constructors

	/** default constructor */
	public WorkflowRequestinfoItems() {
	}

	/** minimal constructor */
	public WorkflowRequestinfoItems(String creatorId, String memberId,
			Long interfaceId, Byte cashFlag, Double total, Date workflowTime,
			Byte flowFlag, Long requestId, Long userId, Long itemId,
			Long workflowId) {
		this.creatorId = creatorId;
		this.memberId = memberId;
		this.interfaceId = interfaceId;
		this.cashFlag = cashFlag;
		this.total = total;
		this.workflowTime = workflowTime;
		this.flowFlag = flowFlag;
		this.requestId = requestId;
		this.userId = userId;
		this.itemId = itemId;
		this.workflowId = workflowId;
	}

	/** full constructor */
	public WorkflowRequestinfoItems(String creatorId, String memberId,
			Long interfaceId, Byte cashFlag, Double total, Date workflowTime,
			Byte flowFlag, Long requestId, String requestInfo, Long userId,
			Long itemId, Long workflowId, String remark) {
		this.creatorId = creatorId;
		this.memberId = memberId;
		this.interfaceId = interfaceId;
		this.cashFlag = cashFlag;
		this.total = total;
		this.workflowTime = workflowTime;
		this.flowFlag = flowFlag;
		this.requestId = requestId;
		this.requestInfo = requestInfo;
		this.userId = userId;
		this.itemId = itemId;
		this.workflowId = workflowId;
		this.remark = remark;
	}

	// Property accessors

	public Long getId() {
		return this.id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getCreatorId() {
		return this.creatorId;
	}

	public void setCreatorId(String creatorId) {
		this.creatorId = creatorId;
	}

	public String getMemberId() {
		return this.memberId;
	}

	public void setMemberId(String memberId) {
		this.memberId = memberId;
	}

	public Long getInterfaceId() {
		return this.interfaceId;
	}

	public void setInterfaceId(Long interfaceId) {
		this.interfaceId = interfaceId;
	}

	public Byte getCashFlag() {
		return this.cashFlag;
	}

	public void setCashFlag(Byte cashFlag) {
		this.cashFlag = cashFlag;
	}

	public Double getTotal() {
		return this.total;
	}

	public void setTotal(Double total) {
		this.total = total;
	}

	public Date getWorkflowTime() {
		return this.workflowTime;
	}

	public void setWorkflowTime(Date workflowTime) {
		this.workflowTime = workflowTime;
	}

	public Byte getFlowFlag() {
		return this.flowFlag;
	}

	public void setFlowFlag(Byte flowFlag) {
		this.flowFlag = flowFlag;
	}

	public Long getRequestId() {
		return this.requestId;
	}

	public void setRequestId(Long requestId) {
		this.requestId = requestId;
	}

	public String getRequestInfo() {
		return this.requestInfo;
	}

	public void setRequestInfo(String requestInfo) {
		this.requestInfo = requestInfo;
	}

	public Long getUserId() {
		return this.userId;
	}

	public void setUserId(Long userId) {
		this.userId = userId;
	}

	public Long getItemId() {
		return this.itemId;
	}

	public void setItemId(Long itemId) {
		this.itemId = itemId;
	}

	public Long getWorkflowId() {
		return this.workflowId;
	}

	public void setWorkflowId(Long workflowId) {
		this.workflowId = workflowId;
	}

	public String getRemark() {
		return this.remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}

}