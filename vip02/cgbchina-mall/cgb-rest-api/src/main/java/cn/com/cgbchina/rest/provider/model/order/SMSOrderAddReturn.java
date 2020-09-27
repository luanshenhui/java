package cn.com.cgbchina.rest.provider.model.order;

import cn.com.cgbchina.rest.provider.model.BaseQueryEntity;

/**
 * MAL401 短信下单接口
 * 
 * @author lizy 2016/4/28.
 */
public class SMSOrderAddReturn extends BaseQueryEntity {

	/**
	 * 
	 */
	private static final long serialVersionUID = -1421407397402571852L;
	private String orderMainId;
	private String amountMoney;
	private String amountPoint;
	private String curStatusId;
	private String returnCode;
	private String returnDes;

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
