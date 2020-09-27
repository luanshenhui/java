package cn.com.cgbchina.rest.visit.model.point;

import java.io.Serializable;

import cn.com.cgbchina.rest.visit.model.BaseQuery;

/**
 * Comment: Created by 11150321050126 on 2016/4/30.
 */
public class QueryPointsInfo extends BaseQuery implements Serializable {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private String channelID;

	private String currentPage;
	private String cardNo;
	private String jgId;
	private String projectCode;
	private String startDate;
	private String endDate;
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

	public String getChannelID() {
		return channelID;
	}

	public void setChannelID(String channelID) {
		this.channelID = channelID;
	}

	public String getCurrentPage() {
		return currentPage;
	}

	public void setCurrentPage(String currentPage) {
		this.currentPage = currentPage;
	}

	public String getCardNo() {
		return cardNo;
	}

	public void setCardNo(String cardNo) {
		this.cardNo = cardNo;
	}

	public String getJgId() {
		return jgId;
	}

	public void setJgId(String jgId) {
		this.jgId = jgId;
	}

	public String getProjectCode() {
		return projectCode;
	}

	public void setProjectCode(String projectCode) {
		this.projectCode = projectCode;
	}

	public String getStartDate() {
		return startDate;
	}

	public void setStartDate(String startDate) {
		this.startDate = startDate;
	}

	public String getEndDate() {
		return endDate;
	}

	public void setEndDate(String endDate) {
		this.endDate = endDate;
	}

}
