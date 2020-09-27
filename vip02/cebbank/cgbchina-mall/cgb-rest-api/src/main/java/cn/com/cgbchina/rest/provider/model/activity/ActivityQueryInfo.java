package cn.com.cgbchina.rest.provider.model.activity;

import java.io.Serializable;

public class ActivityQueryInfo implements Serializable {
	/**
	 * 
	 */
	private static final long serialVersionUID = -7695628943689857357L;
	private String actId;
	private String actNm;
	private String beginDate;
	private String beginTime;
	private String endDate;
	private String endTime;
	private String actDesc;
	private String actStatus;

	public String getActId() {
		return actId;
	}

	public void setActId(String actId) {
		this.actId = actId;
	}

	public String getActNm() {
		return actNm;
	}

	public void setActNm(String actNm) {
		this.actNm = actNm;
	}

	public String getBeginDate() {
		return beginDate;
	}

	public void setBeginDate(String beginDate) {
		this.beginDate = beginDate;
	}

	public String getBeginTime() {
		return beginTime;
	}

	public void setBeginTime(String beginTime) {
		this.beginTime = beginTime;
	}

	public String getEndDate() {
		return endDate;
	}

	public void setEndDate(String endDate) {
		this.endDate = endDate;
	}

	public String getEndTime() {
		return endTime;
	}

	public void setEndTime(String endTime) {
		this.endTime = endTime;
	}

	public String getActDesc() {
		return actDesc;
	}

	public void setActDesc(String actDesc) {
		this.actDesc = actDesc;
	}

	public String getActStatus() {
		return actStatus;
	}

	public void setActStatus(String actStatus) {
		this.actStatus = actStatus;
	}

}
