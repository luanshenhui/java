package cn.com.cgbchina.rest.visit.model.user;

import cn.com.cgbchina.rest.visit.model.BaseResult;

import java.io.Serializable;

import javax.validation.constraints.NotNull;

/**
 * Comment: Created by 11150321050126 on 2016/4/30.
 */
public class MobileValidCode extends BaseResult implements Serializable {
	private static final long serialVersionUID = -6511423514094850478L;
	@NotNull
	private String mobileNo;
	private String backtradeSN;

	public String getMobileNo() {
		return mobileNo;
	}

	public void setMobileNo(String mobileNo) {
		this.mobileNo = mobileNo;
	}

	public String getBacktradeSN() {
		return backtradeSN;
	}

	public void setBacktradeSN(String backtradeSN) {
		this.backtradeSN = backtradeSN;
	}
}
