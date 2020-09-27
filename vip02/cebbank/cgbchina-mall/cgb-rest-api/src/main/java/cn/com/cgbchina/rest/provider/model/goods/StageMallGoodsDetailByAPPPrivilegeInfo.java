package cn.com.cgbchina.rest.provider.model.goods;

import java.io.Serializable;

/**
 * MAL313 商品详细信息(分期商城) App
 * 
 * @author lizy 2016/4/28.
 */
public class StageMallGoodsDetailByAPPPrivilegeInfo implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 7950315503313399960L;
	private String privilegeId;
	private String privilegeName;
	private String projectNO;
	private Double liquidateRatio;
	private Double privilegeMoney;
	private String useActivatiState;
	private String pastDueState;
	private Double limitMoney;
	private String regulation;
	private String beginDate;
	private String endDate;

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

	public String getProjectNO() {
		return projectNO;
	}

	public void setProjectNO(String projectNO) {
		this.projectNO = projectNO;
	}

	public Double getLiquidateRatio() {
		return liquidateRatio;
	}

	public void setLiquidateRatio(Double liquidateRatio) {
		this.liquidateRatio = liquidateRatio;
	}

	public Double getPrivilegeMoney() {
		return privilegeMoney;
	}

	public void setPrivilegeMoney(Double privilegeMoney) {
		this.privilegeMoney = privilegeMoney;
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

	public Double getLimitMoney() {
		return limitMoney;
	}

	public void setLimitMoney(Double limitMoney) {
		this.limitMoney = limitMoney;
	}

	public String getRegulation() {
		return regulation;
	}

	public void setRegulation(String regulation) {
		this.regulation = regulation;
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

}
