package cn.com.cgbchina.rest.provider.vo.order;

import java.io.Serializable;

import javax.validation.constraints.NotNull;

import cn.com.cgbchina.rest.common.annotation.XMLNodeName;
import cn.com.cgbchina.rest.provider.vo.BaseEntityVO;

/**
 * MAL108 CC积分商城订单详细信息返回对象
 * 
 * @author lizy
 */
public class CCIntergralOrderDetailChildrenVO extends BaseEntityVO implements Serializable {
	private static final long serialVersionUID = 4970275452541931083L;
	@NotNull
	private String orderId;
	@NotNull
	private String orderName;
	@NotNull
	private String goodsName;
	@NotNull
	private String goodsNo;
	@NotNull
	private String consumeType;
	@NotNull
	private String intergralNo;
	@NotNull
	private String jfType;
	@NotNull
	private String jfTypeName;
	@NotNull
	private String goodsPrice;
	@NotNull
	@XMLNodeName(value = "vendor_fnm")
	private String vendorFnm;
	@XMLNodeName(value = "virtual_all_mileage")
	private String virtualAllMileage;
	@XMLNodeName(value = "virtual_all_price")
	private String virtualAllPrice;
	@XMLNodeName(value = "virtual_member_id")
	private String virtualMemberId;
	@XMLNodeName(value = "virtual_member_nm")
	private String virtualMemberNm;
	@XMLNodeName(value = "v_aviation_type")
	private String vAviationType;
	private String goodsType;
	@XMLNodeName(value = "do_date")
	private String doDate;
	@XMLNodeName(value = "transcorp_nm")
	private String transcorpNm;
	@XMLNodeName(value = "mailing_mun")
	private String mailingMun;
	@XMLNodeName(value = "service_phone")
	private String servicePhone;

	public static long getSerialVersionUID() {
		return serialVersionUID;
	}

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

	public String getVAviationType() {
		return vAviationType;
	}

	public void setVAviationType(String vAviationType) {
		this.vAviationType = vAviationType;
	}

	public String getGoodsType() {
		return goodsType;
	}

	public void setGoodsType(String goodsType) {
		this.goodsType = goodsType;
	}

	public String getDoDate() {
		return doDate;
	}

	public void setDoDate(String doDate) {
		this.doDate = doDate;
	}

	public String getTranscorpNm() {
		return transcorpNm;
	}

	public void setTranscorpNm(String transcorpNm) {
		this.transcorpNm = transcorpNm;
	}

	public String getMailingMun() {
		return mailingMun;
	}

	public void setMailingMun(String mailingMun) {
		this.mailingMun = mailingMun;
	}

	public String getServicePhone() {
		return servicePhone;
	}

	public void setServicePhone(String servicePhone) {
		this.servicePhone = servicePhone;
	}
}
