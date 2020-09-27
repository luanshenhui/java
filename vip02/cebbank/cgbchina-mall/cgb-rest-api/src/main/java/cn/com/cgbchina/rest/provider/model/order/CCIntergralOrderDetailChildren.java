package cn.com.cgbchina.rest.provider.model.order;

import java.io.Serializable;

import cn.com.cgbchina.rest.provider.model.BaseEntity;

/**
 * MAL108 CC积分商城订单详细信息返回对象
 * 
 * @author lizy
 */
public class CCIntergralOrderDetailChildren extends BaseEntity implements Serializable {
	/**
	 * 
	 */
	private static final long serialVersionUID = 9153695439427938159L;
	private String orderId;
	private String orderName;
	private String goodsName;
	private String goodsNo;
	private String consumeType;
	private String intergralNo;
	private String jfType;
	private String jfTypeName;
	private String goodsPrice;
	private String vendorFnm;
	private String virtualAllMileage;
	private String virtualAllPrice;
	private String virtualMemberId;
	private String virtualMemberNm;
	private String vAviationType;

	public String getOrderId() {
		return orderId;
	}

	public void setOrderId(String orderId) {
		this.orderId = orderId;
	}

	public String getOrderName() {
		return orderName;
	}

	public void setOrderName(String orderName) {
		this.orderName = orderName;
	}

	public String getGoodsName() {
		return goodsName;
	}

	public void setGoodsName(String goodsName) {
		this.goodsName = goodsName;
	}

	public String getGoodsNo() {
		return goodsNo;
	}

	public void setGoodsNo(String goodsNo) {
		this.goodsNo = goodsNo;
	}

	public String getConsumeType() {
		return consumeType;
	}

	public void setConsumeType(String consumeType) {
		this.consumeType = consumeType;
	}

	public String getIntergralNo() {
		return intergralNo;
	}

	public void setIntergralNo(String intergralNo) {
		this.intergralNo = intergralNo;
	}

	public String getJfType() {
		return jfType;
	}

	public void setJfType(String jfType) {
		this.jfType = jfType;
	}

	public String getJfTypeName() {
		return jfTypeName;
	}

	public void setJfTypeName(String jfTypeName) {
		this.jfTypeName = jfTypeName;
	}

	public String getGoodsPrice() {
		return goodsPrice;
	}

	public void setGoodsPrice(String goodsPrice) {
		this.goodsPrice = goodsPrice;
	}

	public String getVendorFnm() {
		return vendorFnm;
	}

	public void setVendorFnm(String vendorFnm) {
		this.vendorFnm = vendorFnm;
	}

	public String getVirtualAllMileage() {
		return virtualAllMileage;
	}

	public void setVirtualAllMileage(String virtualAllMileage) {
		this.virtualAllMileage = virtualAllMileage;
	}

	public String getVirtualAllPrice() {
		return virtualAllPrice;
	}

	public void setVirtualAllPrice(String virtualAllPrice) {
		this.virtualAllPrice = virtualAllPrice;
	}

	public String getVirtualMemberId() {
		return virtualMemberId;
	}

	public void setVirtualMemberId(String virtualMemberId) {
		this.virtualMemberId = virtualMemberId;
	}

	public String getVirtualMemberNm() {
		return virtualMemberNm;
	}

	public void setVirtualMemberNm(String virtualMemberNm) {
		this.virtualMemberNm = virtualMemberNm;
	}

	public String getvAviationType() {
		return vAviationType;
	}

	public void setvAviationType(String vAviationType) {
		this.vAviationType = vAviationType;
	}

	public String getGoodsType() {
		return goodsType;
	}

	public void setGoodsType(String goodsType) {
		this.goodsType = goodsType;
	}

	private String goodsType;

}
