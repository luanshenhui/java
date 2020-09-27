package cn.com.cgbchina.rest.provider.vo.order;

import java.io.Serializable;

import javax.validation.constraints.NotNull;

import cn.com.cgbchina.rest.common.annotation.XMLNodeName;
import cn.com.cgbchina.rest.provider.vo.BaseQueryEntityVO;

/**
 * MAL308 订单查询(分期商城)
 * 
 * @author Lizy
 *
 */
public class StageMallOrdersQueryByAPPVO extends BaseQueryEntityVO implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = -4179361762244623415L;
	@NotNull
	private String origin;
	@NotNull
	@XMLNodeName(value = "cust_id")
	private String custId;
	@NotNull
	private String curStatusId;
	@NotNull
	private String rowsPage;
	@NotNull
	private String currentPage;
	private String orderType;
	@XMLNodeName(value = "cur_status_ids")
	private String curStatusIds;

	public String getOrigin() {
		return origin;
	}

	public void setOrigin(String origin) {
		this.origin = origin;
	}

	public String getCustId() {
		return custId;
	}

	public void setCustId(String custId) {
		this.custId = custId;
	}

	public String getCurStatusId() {
		return curStatusId;
	}

	public void setCurStatusId(String curStatusId) {
		this.curStatusId = curStatusId;
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

	public String getOrderType() {
		return orderType;
	}

	public void setOrderType(String orderType) {
		this.orderType = orderType;
	}

	public String getCurStatusIds() {
		return curStatusIds;
	}

	public void setCurStatusIds(String curStatusIds) {
		this.curStatusIds = curStatusIds;
	}

}
