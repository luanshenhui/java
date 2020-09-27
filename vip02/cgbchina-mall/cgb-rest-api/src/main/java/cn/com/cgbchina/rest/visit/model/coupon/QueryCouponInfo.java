package cn.com.cgbchina.rest.visit.model.coupon;

import cn.com.cgbchina.rest.visit.model.BaseQuery;

import java.io.Serializable;

import javax.validation.constraints.NotNull;

/**
 * Comment: Created by 11150321050126 on 2016/4/30.
 */
public class QueryCouponInfo extends BaseQuery implements Serializable {
	private static final long serialVersionUID = -6319400363840475717L;
	@NotNull
	private String channel;
	@NotNull
	private String qryType;
	@NotNull
	private String rowsPage;
	@NotNull
	private String currentPage;
	private String contIdType;
	@NotNull
	private String contIdCard;
	private String activeCode;
	private String projectNO;
	private String privilegeId;
	private Byte useState;
	private Byte pastDueState;

	public String getChannel() {
		return channel;
	}

	public void setChannel(String channel) {
		this.channel = channel;
	}

	public String getQryType() {
		return qryType;
	}

	public void setQryType(String qryType) {
		this.qryType = qryType;
	}

	public String getRowsPage() {
		return rowsPage;
	}

	public void setRowsPage(String rowsPage) {
		this.rowsPage = rowsPage;
	}

	public String getCurrentPage() {
		return currentPage;
	}

	public void setCurrentPage(String currentPage) {
		this.currentPage = currentPage;
	}

	public String getContIdType() {
		return contIdType;
	}

	public void setContIdType(String contIdType) {
		this.contIdType = contIdType;
	}

	public String getContIdCard() {
		return contIdCard;
	}

	public void setContIdCard(String contIdCard) {
		this.contIdCard = contIdCard;
	}

	public String getActiveCode() {
		return activeCode;
	}

	public void setActiveCode(String activeCode) {
		this.activeCode = activeCode;
	}

	public String getProjectNO() {
		return projectNO;
	}

	public void setProjectNO(String projectNO) {
		this.projectNO = projectNO;
	}

	public String getPrivilegeId() {
		return privilegeId;
	}

	public void setPrivilegeId(String privilegeId) {
		this.privilegeId = privilegeId;
	}

	public Byte getUseState() {
		return useState;
	}

	public void setUseState(Byte useState) {
		this.useState = useState;
	}

	public Byte getPastDueState() {
		return pastDueState;
	}

	public void setPastDueState(Byte pastDueState) {
		this.pastDueState = pastDueState;
	}
}
