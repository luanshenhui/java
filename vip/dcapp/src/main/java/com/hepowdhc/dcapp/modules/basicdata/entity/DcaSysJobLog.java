/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.hepowdhc.dcapp.modules.basicdata.entity;

import java.util.Date;

import org.hibernate.validator.constraints.Length;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.thinkgem.jeesite.common.persistence.DataEntity;

/**
 * dca_sys_job_logEntity
 * 
 * @author huidan.pang
 * @version 2016-11-07
 */
public class DcaSysJobLog extends DataEntity<DcaSysJobLog> {

	private static final long serialVersionUID = 1L;
	private String idJob; // id_job
	private String channelId; // channel_id
	private String jobname; // ETLJob名称
	private String status; // 执行状态（开始：start；结束：end）
	private Long linesRead; // lines_read
	private Long linesWritten; // lines_written
	private Long linesUpdated; // lines_updated
	private Long linesInput; // lines_input
	private Long linesOutput; // lines_output
	private Long linesRejected; // lines_rejected
	private Long errors; // 执行错误数（成功场合：0，失败场合：&gt;0）
	private Date startdate; // 执行开始时间
	private Date enddate; // 执行结束时间
	private Date logdate; // logdate
	private Date depdate; // depdate
	private Date replaydate; // replaydate
	private String logField; // 执行结果log日志

	private String stepname;
	private Date date;
	private String itemerror;
	private String channelid;
	private String idBatch;

	public String getChannelid() {
		return channelid;
	}

	public void setChannelid(String channelid) {
		this.channelid = channelid;
	}

	public String getStepname() {
		return stepname;
	}

	public void setStepName(String stepname) {
		this.stepname = stepname;
	}

	public DcaSysJobLog() {
		super();
	}

	public DcaSysJobLog(String id) {
		super(id);
	}

	@Length(min = 0, max = 11, message = "id_job长度必须介于 0 和 11 之间")
	public String getIdJob() {
		return idJob;
	}

	public void setIdJob(String idJob) {
		this.idJob = idJob;
	}

	@Length(min = 0, max = 255, message = "channel_id长度必须介于 0 和 255 之间")
	public String getChannelId() {
		return channelId;
	}

	public void setChannelId(String channelId) {
		this.channelId = channelId;
	}

	@Length(min = 0, max = 255, message = "ETLJob名称长度必须介于 0 和 255 之间")
	public String getJobname() {
		return jobname;
	}

	public void setJobname(String jobname) {
		this.jobname = jobname;
	}

	@Length(min = 0, max = 15, message = "执行状态（开始：start；结束：end）长度必须介于 0 和 15 之间")
	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public Long getLinesRead() {
		return linesRead;
	}

	public void setLinesRead(Long linesRead) {
		this.linesRead = linesRead;
	}

	public Long getLinesWritten() {
		return linesWritten;
	}

	public void setLinesWritten(Long linesWritten) {
		this.linesWritten = linesWritten;
	}

	public Long getLinesUpdated() {
		return linesUpdated;
	}

	public void setLinesUpdated(Long linesUpdated) {
		this.linesUpdated = linesUpdated;
	}

	public Long getLinesInput() {
		return linesInput;
	}

	public void setLinesInput(Long linesInput) {
		this.linesInput = linesInput;
	}

	public Long getLinesOutput() {
		return linesOutput;
	}

	public void setLinesOutput(Long linesOutput) {
		this.linesOutput = linesOutput;
	}

	public Long getLinesRejected() {
		return linesRejected;
	}

	public void setLinesRejected(Long linesRejected) {
		this.linesRejected = linesRejected;
	}

	public Long getErrors() {
		return errors;
	}

	public void setErrors(Long errors) {
		this.errors = errors;
	}

	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	public Date getStartdate() {
		return startdate;
	}

	public void setStartdate(Date startdate) {
		this.startdate = startdate;
	}

	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	public Date getEnddate() {
		return enddate;
	}

	public void setEnddate(Date enddate) {
		this.enddate = enddate;
	}

	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	public Date getLogdate() {
		return logdate;
	}

	public void setLogdate(Date logdate) {
		this.logdate = logdate;
	}

	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	public Date getDepdate() {
		return depdate;
	}

	public void setDepdate(Date depdate) {
		this.depdate = depdate;
	}

	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	public Date getReplaydate() {
		return replaydate;
	}

	public void setReplaydate(Date replaydate) {
		this.replaydate = replaydate;
	}

	public String getLogField() {
		return logField;
	}

	public void setLogField(String logField) {
		this.logField = logField;
	}

	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	public Date getdate() {
		return date;
	}

	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	public void setdate(Date date) {
		this.date = date;
	}

	public String getItemerror() {
		return itemerror;
	}

	public void setItemerror(String itemerror) {
		this.itemerror = itemerror;
	}

	public String getIdBatch() {
		return idBatch;
	}

	public void setIdBatch(String idBatch) {
		this.idBatch = idBatch;
	}

}