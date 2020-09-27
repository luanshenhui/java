package cn.com.cgbchina.rest.visit.vo.coupon;

import java.util.Date;

/**
 * Comment: Created by 11150321050126 on 2016/4/30.
 */
public class CouponProjectVO {
	private String projectName;
	private String projectNO;
	private String projectIntro;
	private Integer grantTimes;
	private Date beginDate;
	private Date endDate;

	public String getProjectName() {
		return projectName;
	}

	public void setProjectName(String projectName) {
		this.projectName = projectName;
	}

	public String getProjectNO() {
		return projectNO;
	}

	public void setProjectNO(String projectNO) {
		this.projectNO = projectNO;
	}

	public String getProjectIntro() {
		return projectIntro;
	}

	public void setProjectIntro(String projectIntro) {
		this.projectIntro = projectIntro;
	}

	public Integer getGrantTimes() {
		return grantTimes;
	}

	public void setGrantTimes(Integer grantTimes) {
		this.grantTimes = grantTimes;
	}

	public Date getBeginDate() {
		return beginDate;
	}

	public void setBeginDate(Date beginDate) {
		this.beginDate = beginDate;
	}

	public Date getEndDate() {
		return endDate;
	}

	public void setEndDate(Date endDate) {
		this.endDate = endDate;
	}
}
