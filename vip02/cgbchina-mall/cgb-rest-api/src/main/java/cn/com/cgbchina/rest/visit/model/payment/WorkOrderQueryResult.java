package cn.com.cgbchina.rest.visit.model.payment;

import java.io.Serializable;
import java.util.Date;

import javax.validation.constraints.NotNull;

import cn.com.cgbchina.rest.visit.model.BaseResult;

/**
 * Comment: Created by 11150321050126 on 2016/4/29.
 */
public class WorkOrderQueryResult extends BaseResult implements Serializable {

	private static final long serialVersionUID = -5963862443049992868L;
	@NotNull
	private String srcCaseId;
	private String caseId;
	private String processStatus;
	private String processResult;
	private String resultDesc;
	private String primaryKey;
	private String procInstID;
	private String procPriority;
	private String procCreater;
	private Date procCreateTime;
	private String procEnder;
	private Date procEndTime;
	private Date procExpectedEndTime;
	private Byte procIsReply;
	private Byte procIssuspended;
	private String taskId;
	private String priority;
	private Byte isSuspended;
	private Byte isBacked;
	private Byte isCopied;
	private String activityId;
	private String activityName;
	private Date startTime;
	private Date endTime;
	private Date expectedEndTime;
	private String lockeder;
	private Date lockedTime;
	private String creater;
	private String assignee;
	private String handler;
	private String handleResult;
	private String comment;
	private String decisionResult;
	private String prevActivityId;
	private String nextActivityId;
	private String errorCode;

	public String getErrorCode() {
		return errorCode;
	}

	public void setErrorCode(String errorCode) {
		this.errorCode = errorCode;
	}

	public String getSrcCaseId() {
		return srcCaseId;
	}

	public void setSrcCaseId(String srcCaseId) {
		this.srcCaseId = srcCaseId;
	}

	public String getCaseId() {
		return caseId;
	}

	public void setCaseId(String caseId) {
		this.caseId = caseId;
	}

	public String getProcessStatus() {
		return processStatus;
	}

	public void setProcessStatus(String processStatus) {
		this.processStatus = processStatus;
	}

	public String getProcessResult() {
		return processResult;
	}

	public void setProcessResult(String processResult) {
		this.processResult = processResult;
	}

	public String getResultDesc() {
		return resultDesc;
	}

	public void setResultDesc(String resultDesc) {
		this.resultDesc = resultDesc;
	}

	public String getPrimaryKey() {
		return primaryKey;
	}

	public void setPrimaryKey(String primaryKey) {
		this.primaryKey = primaryKey;
	}

	public String getProcInstID() {
		return procInstID;
	}

	public void setProcInstID(String procInstID) {
		this.procInstID = procInstID;
	}

	public String getProcPriority() {
		return procPriority;
	}

	public void setProcPriority(String procPriority) {
		this.procPriority = procPriority;
	}

	public String getProcCreater() {
		return procCreater;
	}

	public void setProcCreater(String procCreater) {
		this.procCreater = procCreater;
	}

	public Date getProcCreateTime() {
		return procCreateTime;
	}

	public void setProcCreateTime(Date procCreateTime) {
		this.procCreateTime = procCreateTime;
	}

	public String getProcEnder() {
		return procEnder;
	}

	public void setProcEnder(String procEnder) {
		this.procEnder = procEnder;
	}

	public Date getProcEndTime() {
		return procEndTime;
	}

	public void setProcEndTime(Date procEndTime) {
		this.procEndTime = procEndTime;
	}

	public Date getProcExpectedEndTime() {
		return procExpectedEndTime;
	}

	public void setProcExpectedEndTime(Date procExpectedEndTime) {
		this.procExpectedEndTime = procExpectedEndTime;
	}

	public String getTaskId() {
		return taskId;
	}

	public void setTaskId(String taskId) {
		this.taskId = taskId;
	}

	public String getPriority() {
		return priority;
	}

	public void setPriority(String priority) {
		this.priority = priority;
	}

	public Byte getProcIsReply() {
		return procIsReply;
	}

	public void setProcIsReply(Byte procIsReply) {
		this.procIsReply = procIsReply;
	}

	public Byte getProcIssuspended() {
		return procIssuspended;
	}

	public void setProcIssuspended(Byte procIssuspended) {
		this.procIssuspended = procIssuspended;
	}

	public Byte getIsSuspended() {
		return isSuspended;
	}

	public void setIsSuspended(Byte isSuspended) {
		this.isSuspended = isSuspended;
	}

	public Byte getIsBacked() {
		return isBacked;
	}

	public void setIsBacked(Byte isBacked) {
		this.isBacked = isBacked;
	}

	public Byte getIsCopied() {
		return isCopied;
	}

	public void setIsCopied(Byte isCopied) {
		this.isCopied = isCopied;
	}

	public String getActivityId() {
		return activityId;
	}

	public void setActivityId(String activityId) {
		this.activityId = activityId;
	}

	public String getActivityName() {
		return activityName;
	}

	public void setActivityName(String activityName) {
		this.activityName = activityName;
	}

	public Date getStartTime() {
		return startTime;
	}

	public void setStartTime(Date startTime) {
		this.startTime = startTime;
	}

	public Date getEndTime() {
		return endTime;
	}

	public void setEndTime(Date endTime) {
		this.endTime = endTime;
	}

	public Date getExpectedEndTime() {
		return expectedEndTime;
	}

	public void setExpectedEndTime(Date expectedEndTime) {
		this.expectedEndTime = expectedEndTime;
	}

	public String getLockeder() {
		return lockeder;
	}

	public void setLockeder(String lockeder) {
		this.lockeder = lockeder;
	}

	public Date getLockedTime() {
		return lockedTime;
	}

	public void setLockedTime(Date lockedTime) {
		this.lockedTime = lockedTime;
	}

	public String getCreater() {
		return creater;
	}

	public void setCreater(String creater) {
		this.creater = creater;
	}

	public String getAssignee() {
		return assignee;
	}

	public void setAssignee(String assignee) {
		this.assignee = assignee;
	}

	public String getHandler() {
		return handler;
	}

	public void setHandler(String handler) {
		this.handler = handler;
	}

	public String getHandleResult() {
		return handleResult;
	}

	public void setHandleResult(String handleResult) {
		this.handleResult = handleResult;
	}

	public String getComment() {
		return comment;
	}

	public void setComment(String comment) {
		this.comment = comment;
	}

	public String getDecisionResult() {
		return decisionResult;
	}

	public void setDecisionResult(String decisionResult) {
		this.decisionResult = decisionResult;
	}

	public String getPrevActivityId() {
		return prevActivityId;
	}

	public void setPrevActivityId(String prevActivityId) {
		this.prevActivityId = prevActivityId;
	}

	public String getNextActivityId() {
		return nextActivityId;
	}

	public void setNextActivityId(String nextActivityId) {
		this.nextActivityId = nextActivityId;
	}
}
