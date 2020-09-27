package cn.com.cgbchina.rest.visit.model.coupon;

import java.io.Serializable;
import java.math.BigDecimal;

import cn.com.cgbchina.rest.visit.model.BaseResult;

/**
 * Comment: Created by 11150321050126 on 2016/4/30.
 */
public class ActivateCouponProjectResutl extends BaseResult implements
		Serializable {
	private static final long serialVersionUID = -558744922958170843L;
	private String projectNO;
	private String sProjectNO;
	private String privilegeId;
	private String privilegeName;
	private BigDecimal privilegeMoney;
	private BigDecimal liquidateRatio;
	private String useActivatiState;
	private String pastDueState;
	private BigDecimal limitMoney;
	private String beginDate;
	private String endDate;
	private String regulation;
	private String returnCode;
	private String returnDes;

	public String getReturnCode() {
		return returnCode;
	}

	public void setReturnCode(String returnCode) {
		this.returnCode = returnCode;
	}

	public String getReturnDes() {
		return returnDes;
	}

	public void setReturnDes(String returnDes) {
		this.returnDes = returnDes;
	}

	public String getProjectNO() {
		return projectNO;
	}

	public void setProjectNO(String projectNO) {
		this.projectNO = projectNO;
	}

	public String getsProjectNO() {
		return sProjectNO;
	}

	public void setsProjectNO(String sProjectNO) {
		this.sProjectNO = sProjectNO;
	}

	public String getPrivilegeId() {
		return privilegeId;
	}

	public void setPrivilegeId(String privilegeId) {
		this.privilegeId = privilegeId;
	}

	public String getPrivilegeName() {
		return privilegeName;
	}

	public void setPrivilegeName(String privilegeName) {
		this.privilegeName = privilegeName;
	}

	public BigDecimal getPrivilegeMoney() {
		return privilegeMoney;
	}

	public void setPrivilegeMoney(BigDecimal privilegeMoney) {
		this.privilegeMoney = privilegeMoney;
	}

	public BigDecimal getLiquidateRatio() {
		return liquidateRatio;
	}

	public void setLiquidateRatio(BigDecimal liquidateRatio) {
		this.liquidateRatio = liquidateRatio;
	}

	public String getUseActivatiState() {
		return useActivatiState;
	}

	public void setUseActivatiState(String useActivatiState) {
		this.useActivatiState = useActivatiState;
	}

	public String getPastDueState() {
		return pastDueState;
	}

	public void setPastDueState(String pastDueState) {
		this.pastDueState = pastDueState;
	}

	public BigDecimal getLimitMoney() {
		return limitMoney;
	}

	public void setLimitMoney(BigDecimal limitMoney) {
		this.limitMoney = limitMoney;
	}

	public String getBeginDate() {
		return beginDate;
	}

	public void setBeginDate(String beginDate) {
		this.beginDate = beginDate;
	}

	public String getEndDate() {
		return endDate;
	}

	public void setEndDate(String endDate) {
		this.endDate = endDate;
	}

	public String getRegulation() {
		return regulation;
	}

	public void setRegulation(String regulation) {
		this.regulation = regulation;
	}
}
