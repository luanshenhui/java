package cn.com.cgbchina.rest.visit.vo.coupon;

import java.io.Serializable;

import cn.com.cgbchina.rest.common.annotation.XMLNodeName;
import cn.com.cgbchina.rest.visit.vo.BaseQueryVo;

/**
 * Comment: Created by 11150321050126 on 2016/4/30.
 */
public class CouponProjectPageVO extends BaseQueryVo implements Serializable {
	private String channel;
	private String rowsPage;
	private String currentPage;
	private String qryType;
	@XMLNodeName(value = "cont_id_type")
	private String contIdType;
	@XMLNodeName(value = "cont_idcard")
	private String contIdCard;
	private String projectNO;
	private String privilegeId;
	private String useState;
	private String pastDueState;

	public String getQryType() {
		return qryType;
	}

	public void setQryType(String qryType) {
		this.qryType = qryType;
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

	public String getUseState() {
		return useState;
	}

	public void setUseState(String useState) {
		this.useState = useState;
	}

	public String getPastDueState() {
		return pastDueState;
	}

	public void setPastDueState(String pastDueState) {
		this.pastDueState = pastDueState;
	}

	public String getChannel() {
		return channel;
	}

	public void setChannel(String channel) {
		this.channel = channel;
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

}
