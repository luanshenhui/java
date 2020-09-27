/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.hepowdhc.dcapp.modules.basicdata.entity;

import org.hibernate.validator.constraints.Length;
import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;

import com.thinkgem.jeesite.common.persistence.DataEntity;

/**
 * 数据版本Entity
 * @author dhc
 * @version 2017-01-18
 */
public class DcaEtlJobItemLog extends DataEntity<DcaEtlJobItemLog> {
	
	private static final long serialVersionUID = 1L;
	private Long idBatch;		// id_batch
	private String channelId;		// channel_id
	private Date logDate;		// log_date
	private String transname;		// transname
	private String stepname;		// stepname
	private Long linesRead;		// lines_read
	private Long linesWritten;		// lines_written
	private Long linesUpdated;		// lines_updated
	private Long linesInput;		// lines_input
	private Long linesOutput;		// lines_output
	private Long linesRejected;		// lines_rejected
	private Long errors;		// errors
	private String result;		// result
	private Long nrResultRows;		// nr_result_rows
	private Long nrResultFiles;		// nr_result_files
	
	public DcaEtlJobItemLog() {
		super();
	}

	public DcaEtlJobItemLog(String id){
		super(id);
	}

	public Long getIdBatch() {
		return idBatch;
	}

	public void setIdBatch(Long idBatch) {
		this.idBatch = idBatch;
	}
	
	@Length(min=0, max=255, message="channel_id长度必须介于 0 和 255 之间")
	public String getChannelId() {
		return channelId;
	}

	public void setChannelId(String channelId) {
		this.channelId = channelId;
	}
	
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	public Date getLogDate() {
		return logDate;
	}

	public void setLogDate(Date logDate) {
		this.logDate = logDate;
	}
	
	@Length(min=0, max=255, message="transname长度必须介于 0 和 255 之间")
	public String getTransname() {
		return transname;
	}

	public void setTransname(String transname) {
		this.transname = transname;
	}
	
	@Length(min=0, max=255, message="stepname长度必须介于 0 和 255 之间")
	public String getStepname() {
		return stepname;
	}

	public void setStepname(String stepname) {
		this.stepname = stepname;
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
	
	@Length(min=0, max=1, message="result长度必须介于 0 和 1 之间")
	public String getResult() {
		return result;
	}

	public void setResult(String result) {
		this.result = result;
	}
	
	public Long getNrResultRows() {
		return nrResultRows;
	}

	public void setNrResultRows(Long nrResultRows) {
		this.nrResultRows = nrResultRows;
	}
	
	public Long getNrResultFiles() {
		return nrResultFiles;
	}

	public void setNrResultFiles(Long nrResultFiles) {
		this.nrResultFiles = nrResultFiles;
	}
	
}