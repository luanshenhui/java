package cn.com.cgbchina.rest.visit.model.point;

import java.io.Serializable;
import java.util.List;

import cn.com.cgbchina.rest.visit.model.BaseResult;

/**
 * Comment: Created by 11150321050126 on 2016/4/30.
 */
public class QueryPointResult extends BaseResult implements Serializable {
	private static final long serialVersionUID = -1505792041309955500L;
	private String channelId;
	private String midId;
	private String midTime;
	private String midSN;
	private String midTag;
	private String successCode;
	private String currentPage;
	private String totalPages;
	private String templateId;
	private String loopTag;
	private String loopCount;
	private String loopColumns;
	private List<QueryPointsInfoResult> queryPointsInfoResults;

	public String getChannelId() {
		return channelId;
	}

	public void setChannelId(String channelId) {
		this.channelId = channelId;
	}

	public String getMidId() {
		return midId;
	}

	public void setMidId(String midId) {
		this.midId = midId;
	}

	public String getMidTime() {
		return midTime;
	}

	public void setMidTime(String midTime) {
		this.midTime = midTime;
	}

	public String getMidSN() {
		return midSN;
	}

	public void setMidSN(String midSN) {
		this.midSN = midSN;
	}

	public String getMidTag() {
		return midTag;
	}

	public void setMidTag(String midTag) {
		this.midTag = midTag;
	}

	public String getSuccessCode() {
		return successCode;
	}

	public void setSuccessCode(String successCode) {
		this.successCode = successCode;
	}

	public String getCurrentPage() {
		return currentPage;
	}

	public void setCurrentPage(String currentPage) {
		this.currentPage = currentPage;
	}

	public String getTotalPages() {
		return totalPages;
	}

	public void setTotalPages(String totalPages) {
		this.totalPages = totalPages;
	}

	public String getTemplateId() {
		return templateId;
	}

	public void setTemplateId(String templateId) {
		this.templateId = templateId;
	}

	public String getLoopTag() {
		return loopTag;
	}

	public void setLoopTag(String loopTag) {
		this.loopTag = loopTag;
	}

	public String getLoopCount() {
		return loopCount;
	}

	public void setLoopCount(String loopCount) {
		this.loopCount = loopCount;
	}

	public String getLoopColumns() {
		return loopColumns;
	}

	public void setLoopColumns(String loopColumns) {
		this.loopColumns = loopColumns;
	}

	public List<QueryPointsInfoResult> getQueryPointsInfoResults() {
		return queryPointsInfoResults;
	}

	public void setQueryPointsInfoResults(List<QueryPointsInfoResult> queryPointsInfoResults) {
		this.queryPointsInfoResults = queryPointsInfoResults;
	}

}
