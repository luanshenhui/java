package cn.com.cgbchina.rest.visit.model.coupon;

import java.io.Serializable;
import java.util.Date;

import cn.com.cgbchina.rest.common.annotation.Special;

/**
 * Comment: Created by 11150321050126 on 2016/4/30.
 */
public class CouponProject implements Serializable {
	private static final long serialVersionUID = 7645077749226602334L;
	private String projectName;
	private String projectNO;
	private String projectIntro;
	private Integer grantTimes;
	@Special("yyyyMMdd")
	private Date beginDate;
	@Special("yyyyMMdd")
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
