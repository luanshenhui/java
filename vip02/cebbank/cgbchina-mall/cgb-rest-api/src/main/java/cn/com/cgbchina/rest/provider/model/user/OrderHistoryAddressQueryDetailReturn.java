package cn.com.cgbchina.rest.provider.model.user;

import java.io.Serializable;

/**
 * MAL114 订单历史地址信息查询返回对象
 * 
 * @author lizy 2016/4/28.
 */
public class OrderHistoryAddressQueryDetailReturn implements Serializable {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1578636664743347765L;
	public String postCode;
	public String csgProvince;
	public String csgCity;
	public String csgBorough;
	public String deliveryAddr;
	public String deliveryName;
	public String deliveryMobile;
	public String deliveryPhone;
	public String promotors;
	public String updateDate;
	public String updateTime;

	public String getPostCode() {
		return postCode;
	}

	public void setPostCode(String postCode) {
		this.postCode = postCode;
	}

	public String getCsgProvince() {
		return csgProvince;
	}

	public void setCsgProvince(String csgProvince) {
		this.csgProvince = csgProvince;
	}

	public String getCsgCity() {
		return csgCity;
	}

	public void setCsgCity(String csgCity) {
		this.csgCity = csgCity;
	}

	public String getCsgBorough() {
		return csgBorough;
	}

	public void setCsgBorough(String csgBorough) {
		this.csgBorough = csgBorough;
	}

	public String getDeliveryAddr() {
		return deliveryAddr;
	}

	public void setDeliveryAddr(String deliveryAddr) {
		this.deliveryAddr = deliveryAddr;
	}

	public String getDeliveryName() {
		return deliveryName;
	}

	public void setDeliveryName(String deliveryName) {
		this.deliveryName = deliveryName;
	}

	public String getDeliveryMobile() {
		return deliveryMobile;
	}

	public void setDeliveryMobile(String deliveryMobile) {
		this.deliveryMobile = deliveryMobile;
	}

	public String getDeliveryPhone() {
		return deliveryPhone;
	}

	public void setDeliveryPhone(String deliveryPhone) {
		this.deliveryPhone = deliveryPhone;
	}

	public String getPromotors() {
		return promotors;
	}

	public void setPromotors(String promotors) {
		this.promotors = promotors;
	}

	public String getUpdateDate() {
		return updateDate;
	}

	public void setUpdateDate(String updateDate) {
		this.updateDate = updateDate;
	}

	public String getUpdateTime() {
		return updateTime;
	}

	public void setUpdateTime(String updateTime) {
		this.updateTime = updateTime;
	}

}
