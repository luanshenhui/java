package cn.com.cgbchina.rest.provider.model.order;

import cn.com.cgbchina.rest.provider.model.BaseEntity;

import java.io.Serializable;

/**
 * MAL309 订单查询(分期商城)
 * 
 * @author Lizy
 *
 */
public class StageMallOrdersDoByAPPReturn extends BaseEntity implements Serializable {
	/**
	 * 
	 */
	private static final long serialVersionUID = 3927786898361210729L;
	private String operTime;
	private String orderComments;
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
