package cn.com.cgbchina.rest.visit.model.coupon;

import java.io.Serializable;

import cn.com.cgbchina.rest.common.annotation.XMLNodeName;
import cn.com.cgbchina.rest.visit.vo.BaseQueryVo;

/**
 * Comment: Created by 11150321050126 on 2016/4/30.
 */
public class CouponProjectPage extends BaseQueryVo implements Serializable {
	private static final long serialVersionUID = -1466993610560997188L;
	private String channel;
	private String rowsPage;
	private String currentPage;
	private String qryType;
	@XMLNodeName(value = "cont_id_type")
	private String contIdType;
	@XMLNodeName(value = "cont_idcard")
	private String contIdCard;
	private String projectNO;

	public String getProjectNO() {
		return projectNO;
	}

	public void setProjectNO(String projectNO) {
		this.projectNO = projectNO;
	}

	private String privilegeId;
	private Byte useState;
	private Byte pastDueState;

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
