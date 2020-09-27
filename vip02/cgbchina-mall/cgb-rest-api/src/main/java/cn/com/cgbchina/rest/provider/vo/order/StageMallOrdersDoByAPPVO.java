package cn.com.cgbchina.rest.provider.vo.order;

import cn.com.cgbchina.rest.common.annotation.XMLNodeName;
import cn.com.cgbchina.rest.provider.vo.BaseEntityVO;

import java.io.Serializable;

/**
 * MAL309 订单查询(分期商城)
 * 
 * @author Lizy
 *
 */
public class StageMallOrdersDoByAPPVO implements Serializable {
	/**
	 * 
	 */
	private static final long serialVersionUID = 3927786898361200729L;
	@XMLNodeName(value = "operTime")
	private String operTime;
	@XMLNodeName(value = "orderComments")
	private String orderComments;
	@XMLNodeName(value = "operateName")
	private String operateName;


	public String getOperTime() {
		return operTime;
	}

	public void setOperTime(String operTime) {
		this.operTime = operTime;
	}

	public String getOrderComments() {
		return orderComments;
	}

	public void setOrderComments(String orderComments) {
		this.orderComments = orderComments;
	}

	public String getOperateName() {
		return operateName;
	}

	public void setOperateName(String operateName) {
		this.operateName = operateName;
	}
}
