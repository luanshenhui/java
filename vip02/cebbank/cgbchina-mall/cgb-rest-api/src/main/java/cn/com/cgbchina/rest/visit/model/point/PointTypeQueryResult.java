package cn.com.cgbchina.rest.visit.model.point;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import cn.com.cgbchina.rest.visit.model.BaseResult;

/**
 * Comment: Created by 11150321050126 on 2016/4/29.
 */
public class PointTypeQueryResult extends BaseResult implements Serializable {
	private static final long serialVersionUID = 5570798531472362876L;
	private String channelID;
	private String successCode;
	private String totalPages;
	private String currentPage;
	private List<PointTypeInfo> pointTypeInfos = new ArrayList<PointTypeInfo>();
	private String loopTag;
	private String loopCount;
	private String loopColumns;
	private String midID;
	private String midTime;
	private String midSN;
	private String midTag;

	public String getMidID() {
		return midID;
	}

	public void setMidID(String midID) {
		this.midID = midID;
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

	public String getChannelID() {
		return channelID;
	}

	public void setChannelID(String channelID) {
		this.channelID = channelID;
	}

	public String getSuccessCode() {
		return successCode;
	}

	public void setSuccessCode(String successCode) {
		this.successCode = successCode;
	}

	public String getTotalPages() {
		return totalPages;
	}

	public void setTotalPages(String totalPages) {
		this.totalPages = totalPages;
	}

	public String getCurrentPage() {
		return currentPage;
	}

	public void setCurrentPage(String currentPage) {
		this.currentPage = currentPage;
	}

	public List<PointTypeInfo> getPointTypeInfos() {
		return pointTypeInfos;
	}

	public void setPointTypeInfos(List<PointTypeInfo> pointTypeInfos) {
		this.pointTypeInfos = pointTypeInfos;
	}
}
