package cn.com.cgbchina.rest.provider.vo.activity;

import java.io.Serializable;

import cn.com.cgbchina.rest.common.annotation.XMLNodeName;

public class ActivityQueryInfoVO implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = -4658724313586533736L;
	@XMLNodeName(value = "act_id")
	private String actId;
	@XMLNodeName(value = "act_nm")
	private String actNm;
	private String beginDate;
	private String beginTime;
	private String endDate;
	private String endTime;
	@XMLNodeName(value = "act_desc")
	private String actDesc;
	@XMLNodeName(value = "act_status")
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
