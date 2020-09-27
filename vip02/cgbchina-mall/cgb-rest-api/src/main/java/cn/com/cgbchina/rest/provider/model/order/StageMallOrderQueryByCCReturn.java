package cn.com.cgbchina.rest.provider.model.order;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import cn.com.cgbchina.rest.provider.model.BaseEntity;
import cn.com.cgbchina.rest.provider.vo.order.StageMallOrderQueryByCCDetailVO;

/**
 * @author lizy 2016/4/27.
 *
 *         MAL113 订单信息查询(分期商城)返回对象
 * 
 */
public class StageMallOrderQueryByCCReturn extends BaseEntity implements Serializable {
	private static final long serialVersionUID = -5416694008845564430L;
	private String returnCode;
	private String returnDes;
	private String totalPages;
	private List<StageMallOrderQueryByCCDetail> orders = new ArrayList<StageMallOrderQueryByCCDetail>();

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

	public String getTotalPages() {
		return totalPages;
	}

	public void setTotalPages(String totalPages) {
		this.totalPages = totalPages;
	}

	public List<StageMallOrderQueryByCCDetail> getOrders() {
		return orders;
	}

	public void setOrders(List<StageMallOrderQueryByCCDetail> orders) {
		this.orders = orders;
	}

}
