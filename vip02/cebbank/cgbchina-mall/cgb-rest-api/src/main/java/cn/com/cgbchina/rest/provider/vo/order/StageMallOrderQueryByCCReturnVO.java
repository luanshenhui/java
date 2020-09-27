package cn.com.cgbchina.rest.provider.vo.order;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import javax.validation.constraints.NotNull;

import cn.com.cgbchina.rest.provider.vo.BaseEntityVO;

/**
 * @author lizy 2016/4/27.
 *
 *         MAL113 订单信息查询(分期商城)返回对象
 * 
 */
public class StageMallOrderQueryByCCReturnVO extends BaseEntityVO implements Serializable {
	private static final long serialVersionUID = -5416694008845564430L;
	@NotNull
	private String returnCode;
	private String returnDes;
	private String totalPages;
	private List<StageMallOrderQueryByCCDetailVO> orders = new ArrayList<StageMallOrderQueryByCCDetailVO>();

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

	public List<StageMallOrderQueryByCCDetailVO> getOrders() {
		return orders;
	}

	public void setOrders(List<StageMallOrderQueryByCCDetailVO> orders) {
		this.orders = orders;
	}

}
