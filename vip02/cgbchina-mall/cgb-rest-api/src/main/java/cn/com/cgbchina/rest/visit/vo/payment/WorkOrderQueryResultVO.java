package cn.com.cgbchina.rest.visit.vo.payment;

import java.io.Serializable;
import java.util.Date;

import cn.com.cgbchina.rest.common.annotation.XMLNodeName;
import cn.com.cgbchina.rest.visit.vo.BaseResultVo;

/**
 * Comment: Created by 11150321050126 on 2016/4/29.
 */
public class WorkOrderQueryResultVO extends BaseResultVo implements Serializable {
	@XMLNodeName("SRCCASEID")
	private String srcCaseId;
	@XMLNodeName("CASEID")
	private String caseId;
	@XMLNodeName("PROCESSSTATUS")
	private String processStatus;
	@XMLNodeName("PROCESSRESULT")
	private String processResult;
	@XMLNodeName("RESULTDESC")
	private String resultDesc;
	@XMLNodeName("PRIMARYKEY")
	private String primaryKey;
	@XMLNodeName("PROCINSTID")
	private String procInstID;
	@XMLNodeName("PROCPRIORITY")
	private String procPriority;
	@XMLNodeName("PROCCREATER")
	private String procCreater;
	@XMLNodeName("PROCCREATETIME")
	private Date procCreateTime;
	@XMLNodeName("PROCENDER")
	private String procEnder;
	@XMLNodeName("PROCENDTIME")
	private Date procEndTime;
	@XMLNodeName("PROCEXPECTEDENDTIME")
	private Date procExpectedEndTime;
	@XMLNodeName("PROCISREPLY")
	private Byte procIsReply;
	@XMLNodeName("PROCISSUSPENDED")
	private Byte procIssuspended;
	@XMLNodeName("TASKID")
	private String taskId;
	@XMLNodeName("PRIORITY")
	private String priority;
	@XMLNodeName("ISSUSPENDED")
	private Byte isSuspended;
	@XMLNodeName("ISBACKED")
	private Byte isBacked;
	@XMLNodeName("ISCOPIED")
	private Byte isCopied;
	@XMLNodeName("ACTIVITYID")
	private String activityId;
	@XMLNodeName("ACTIVITYNAME")
	private String activityName;
	@XMLNodeName("STARTTIME")
	private Date startTime;
	@XMLNodeName("ENDTIME")
	private Date endTime;
	@XMLNodeName("EXPECTEDENDTIME")
	private Date expectedEndTime;
	@XMLNodeName("LOCKEDER")
	private String lockeder;
	@XMLNodeName("LOCKEDTIME")
	private Date lockedTime;
	@XMLNodeName("CREATER")
	private String creater;
	@XMLNodeName("ASSIGNEE")
	private String assignee;
	@XMLNodeName("HANDLER")
	private String handler;
	@XMLNodeName("HANDLERESULT")
	private String handleResult;
	@XMLNodeName("COMMENT")
	private String comment;
	@XMLNodeName("DECISIONRESULT")
	private String decisionResult;
	@XMLNodeName("PREVACTIVITYID")
	private String prevActivityId;
	@XMLNodeName("NEXTACTIVITYID")
	private String nextActivityId;
	@XMLNodeName("ERRORCODE")
	private String errorCode;

	public String getErrorCode() {
		return errorCode;
	}

	public void setErrorCode(String errorCode) {
		this.errorCode = errorCode;
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
