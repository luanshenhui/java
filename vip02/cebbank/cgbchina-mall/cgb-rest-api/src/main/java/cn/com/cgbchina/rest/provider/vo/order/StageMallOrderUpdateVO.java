package cn.com.cgbchina.rest.provider.vo.order;

import java.io.Serializable;

import javax.validation.constraints.NotNull;

import cn.com.cgbchina.rest.common.annotation.XMLNodeName;
import cn.com.cgbchina.rest.provider.vo.BaseQueryEntityVO;

/**
 * @author Lizy MAL109 订单修改(分期商城) 对象
 * 
 */
public class StageMallOrderUpdateVO extends BaseQueryEntityVO implements Serializable {
	private static final long serialVersionUID = -8192577953206570553L;
	@NotNull
	private String origin;
	@NotNull
	private String mallType;
	@NotNull
	private String orderMainId;
	private String postCode;
	@XMLNodeName(value = "csg_province")
	private String csgProvince;
	@XMLNodeName(value = "csg_city")
	private String csgCity;
	@XMLNodeName(value = "csg_borough")
	private String csgBorough;
	private String deliveryAddr;
	private String deliveryName;
	private String deliveryMobile;
	private String deliveryPhone;
	private String promotors;

	public String getOrigin() {
		return origin;
	}

	public void setOrigin(String origin) {
		this.origin = origin;
	}

	public String getMallType() {
		return mallType;
	}

	public void setMallType(String mallType) {
		this.mallType = mallType;
	}

	public String getOrderMainId() {
		return orderMainId;
	}

	public void setOrderMainId(String orderMainId) {
		this.orderMainId = orderMainId;
	}

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
}
