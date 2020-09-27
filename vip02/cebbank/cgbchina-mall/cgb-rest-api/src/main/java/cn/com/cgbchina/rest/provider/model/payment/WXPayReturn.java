package cn.com.cgbchina.rest.provider.model.payment;

import java.io.Serializable;
import java.util.List;

import cn.com.cgbchina.rest.provider.model.BaseEntity;

/**
 * MAL503 微信发起支付接口
 * 
 * @author lizy 2016/4/28.
 */
public class WXPayReturn extends BaseEntity implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 5279417236876942288L;
	private String orderMainId;
	private String amountMoney;
	private String amountPoint;
	private String curStatusId;
	private List<OrderIdAndOrderStauts> orders;

	public List<OrderIdAndOrderStauts> getOrders() {
		return orders;
	}

	public void setOrders(List<OrderIdAndOrderStauts> orders) {
		this.orders = orders;
	}

	public String getOrderMainId() {
		return orderMainId;
	}

	public void setOrderMainId(String orderMainId) {
		this.orderMainId = orderMainId;
	}

	public String getAmountMoney() {
		return amountMoney;
	}

	public void setAmountMoney(String amountMoney) {
		this.amountMoney = amountMoney;
	}

	public String getAmountPoint() {
		return amountPoint;
	}

	public void setAmountPoint(String amountPoint) {
		this.amountPoint = amountPoint;
	}

	public String getCurStatusId() {
		return curStatusId;
	}

	public void setCurStatusId(String curStatusId) {
		this.curStatusId = curStatusId;
	}

}
