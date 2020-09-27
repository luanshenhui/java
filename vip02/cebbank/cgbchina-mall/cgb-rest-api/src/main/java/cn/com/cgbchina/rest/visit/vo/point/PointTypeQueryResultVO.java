package cn.com.cgbchina.rest.visit.vo.point;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import javax.validation.constraints.NotNull;

import cn.com.cgbchina.rest.visit.vo.BaseResultVo;

/**
 * Comment: Created by 11150321050126 on 2016/4/29.
 */
public class PointTypeQueryResultVO extends BaseResultVo implements Serializable {
	private String returnCode;
	private String channelID;
	@NotNull
	private String successCode;
	@NotNull
	private String totalPages;
	@NotNull
	private String currentPage;
	private List<PointTypeInfoVO> pointTypeInfos = new ArrayList<PointTypeInfoVO>();
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

	public String getReturnCode() {
		return returnCode;
	}

	public void setReturnCode(String returnCode) {
		this.returnCode = returnCode;
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

	public List<PointTypeInfoVO> getPointTypeInfos() {
		return pointTypeInfos;
	}

	public void setPointTypeInfos(List<PointTypeInfoVO> pointTypeInfos) {
		this.pointTypeInfos = pointTypeInfos;
	}
}
