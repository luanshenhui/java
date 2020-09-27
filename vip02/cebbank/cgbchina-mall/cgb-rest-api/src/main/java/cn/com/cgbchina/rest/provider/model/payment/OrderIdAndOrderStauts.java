package cn.com.cgbchina.rest.provider.model.payment;

import java.io.Serializable;

import cn.com.cgbchina.rest.provider.model.BaseEntity;

/**
 * MAL503 微信发起支付接口list泛型类
 * 
 * @author zjq 2016/6/24.
 */
public class OrderIdAndOrderStauts extends BaseEntity implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 2406313997877947279L;
	private String orderMainId;
	private String curStatusId;

	public String getCurStatusId() {
		return curStatusId;
	}

	public void setCurStatusId(String curStatusId) {
		this.curStatusId = curStatusId;
	}

	public String getOrderMainId() {
		return orderMainId;
	}

	public void setOrderMainId(String orderMainId) {
		this.orderMainId = orderMainId;
	}

}
