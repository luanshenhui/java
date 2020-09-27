package cn.com.cgbchina.rest.provider.vo.order;

import java.io.Serializable;

import cn.com.cgbchina.rest.common.annotation.XMLNodeName;
import cn.com.cgbchina.rest.provider.vo.BaseEntityVO;

/**
 * @author lizy 2016/4/27. MAL111 订单详细信息查询(分期商城) 返回对象
 */
public class StageMallOrderDetailReturnVO extends BaseEntityVO implements
		Serializable {
	private static final long serialVersionUID = -5061654491582166467L;
	@XMLNodeName(value = "order_id")
	private String orderId;
	@XMLNodeName(value = "cur_status_id")
	private String curStatusId;
	@XMLNodeName(value = "goodssend_flag")
	private String goodssendFlag;
	@XMLNodeName(value = "create_date")
	private String createDate;
	@XMLNodeName(value = "goodssend_date")
	private String goodssendDate;
	@XMLNodeName(value = "is_invoice")
	private String isInvoice;
	@XMLNodeName(value = "invoice_type")
	private String invoiceType;
	private String invoice;
	@XMLNodeName(value = "invoice_content")
	private String invoiceContent;
	@XMLNodeName(value = "ordermain_desc")
	private String ordermainDesc;
	@XMLNodeName(value = "csg_province")
	private String csgProvince;
	@XMLNodeName(value = "csg_city")
	private String csgCity;
	@XMLNodeName(value = "csg_borough")
	private String csgBorough;
	@XMLNodeName(value = "csg_address")
	private String csgAddress;
	@XMLNodeName(value = "csg_name")
	private String csgName;
	@XMLNodeName(value = "csg_postcode")
	private String csgPostcode;
	@XMLNodeName(value = "csg_phone1")
	private String csgPhone1;
	@XMLNodeName(value = "csg_phone2")
	private String csgPhone2;
	@XMLNodeName(value = "goods_oid")
	private String goodsOid;
	@XMLNodeName(value = "goods_mid")
	private String goodsMid;
	@XMLNodeName(value = "goods_nm")
	private String goodsNm;
	@XMLNodeName(value = "goods_num")
	private String goodsNum;
	@XMLNodeName(value = "pre_price")
	private String prePrice;
	@XMLNodeName(value = "single_price")
	private String singlePrice;
	@XMLNodeName(value = "stages_num")
	private String stagesNum;
	@XMLNodeName(value = "per_stage")
	private String perStage;
	@XMLNodeName(value = "goods_size")
	private String goodsSize;
	@XMLNodeName(value = "goods_color")
	private String goodsColor;
	@XMLNodeName(value = "mailing_num")
	private String mailingNum;
	@XMLNodeName(value = "service_url")
	private String serviceUrl;
	private String phone;
	@XMLNodeName(value = "goods_present")
	private String goodsPresent;
	@XMLNodeName(value = "vendor_id")
	private String vendorId;
	@XMLNodeName(value = "vendor_fnm")
	private String vendorFnm;
	private String privilegeId;
	private String privilegeName;
	private Double privilegeMoney;
	private String discountPrivilege;
	private String discountPrivMon;

	public String getOrderId() {
		return orderId;
	}

	public void setOrderId(String orderId) {
		this.orderId = orderId;
	}

	public String getCurStatusId() {
		return curStatusId;
	}

	public void setCurStatusId(String curStatusId) {
		this.curStatusId = curStatusId;
	}

	public String getCreateDate() {
		return createDate;
	}

	public void setCreateDate(String createDate) {
		this.createDate = createDate;
	}

	public String getIsInvoice() {
		return isInvoice;
	}

	public void setIsInvoice(String isInvoice) {
		this.isInvoice = isInvoice;
	}

	public String getInvoiceType() {
		return invoiceType;
	}

	public void setInvoiceType(String invoiceType) {
		this.invoiceType = invoiceType;
	}

	public String getInvoice() {
		return invoice;
	}

	public void setInvoice(String invoice) {
		this.invoice = invoice;
	}

	public String getOrdermainDesc() {
		return ordermainDesc;
	}

	public void setOrdermainDesc(String ordermainDesc) {
		this.ordermainDesc = ordermainDesc;
	}

	public String getCsgProvince() {
		return csgProvince;
	}

	public String getGoodssendFlag() {
		return goodssendFlag;
	}

	public void setGoodssendFlag(String goodssendFlag) {
		this.goodssendFlag = goodssendFlag;
	}

	public String getGoodssendDate() {
		return goodssendDate;
	}

	public void setGoodssendDate(String goodssendDate) {
		this.goodssendDate = goodssendDate;
	}

	public String getInvoiceContent() {
		return invoiceContent;
	}

	public void setInvoiceContent(String invoiceContent) {
		this.invoiceContent = invoiceContent;
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

	public String getCsgAddress() {
		return csgAddress;
	}

	public void setCsgAddress(String csgAddress) {
		this.csgAddress = csgAddress;
	}

	public String getCsgName() {
		return csgName;
	}

	public void setCsgName(String csgName) {
		this.csgName = csgName;
	}

	public String getCsgPostcode() {
		return csgPostcode;
	}

	public void setCsgPostcode(String csgPostcode) {
		this.csgPostcode = csgPostcode;
	}

	public String getCsgPhone1() {
		return csgPhone1;
	}

	public void setCsgPhone1(String csgPhone1) {
		this.csgPhone1 = csgPhone1;
	}

	public String getCsgPhone2() {
		return csgPhone2;
	}

	public void setCsgPhone2(String csgPhone2) {
		this.csgPhone2 = csgPhone2;
	}

	public String getGoodsOid() {
		return goodsOid;
	}

	public void setGoodsOid(String goodsOid) {
		this.goodsOid = goodsOid;
	}

	public String getGoodsMid() {
		return goodsMid;
	}

	public void setGoodsMid(String goodsMid) {
		this.goodsMid = goodsMid;
	}

	public String getGoodsNm() {
		return goodsNm;
	}

	public void setGoodsNm(String goodsNm) {
		this.goodsNm = goodsNm;
	}

	public String getGoodsNum() {
		return goodsNum;
	}

	public void setGoodsNum(String goodsNum) {
		this.goodsNum = goodsNum;
	}

	public String getPrePrice() {
		return prePrice;
	}

	public void setPrePrice(String prePrice) {
		this.prePrice = prePrice;
	}

	public String getSinglePrice() {
		return singlePrice;
	}

	public void setSinglePrice(String singlePrice) {
		this.singlePrice = singlePrice;
	}

	public String getStagesNum() {
		return stagesNum;
	}

	public void setStagesNum(String stagesNum) {
		this.stagesNum = stagesNum;
	}

	public String getPerStage() {
		return perStage;
	}

	public void setPerStage(String perStage) {
		this.perStage = perStage;
	}

	public String getGoodsSize() {
		return goodsSize;
	}

	public void setGoodsSize(String goodsSize) {
		this.goodsSize = goodsSize;
	}

	public String getGoodsColor() {
		return goodsColor;
	}

	public void setGoodsColor(String goodsColor) {
		this.goodsColor = goodsColor;
	}

	public String getMailingNum() {
		return mailingNum;
	}

	public void setMailingNum(String mailingNum) {
		this.mailingNum = mailingNum;
	}

	public String getServiceUrl() {
		return serviceUrl;
	}

	public void setServiceUrl(String serviceUrl) {
		this.serviceUrl = serviceUrl;
	}

	public String getPhone() {
		return phone;
	}

	public void setPhone(String phone) {
		this.phone = phone;
	}

	public String getGoodsPresent() {
		return goodsPresent;
	}

	public void setGoodsPresent(String goodsPresent) {
		this.goodsPresent = goodsPresent;
	}

	public String getVendorId() {
		return vendorId;
	}

	public void setVendorId(String vendorId) {
		this.vendorId = vendorId;
	}

	public String getVendorFnm() {
		return vendorFnm;
	}

	public void setVendorFnm(String vendorFnm) {
		this.vendorFnm = vendorFnm;
	}

	public String getPrivilegeId() {
		return privilegeId;
	}

	public void setPrivilegeId(String privilegeId) {
		this.privilegeId = privilegeId;
	}

	public String getPrivilegeName() {
		return privilegeName;
	}

	public void setPrivilegeName(String privilegeName) {
		this.privilegeName = privilegeName;
	}

	public Double getPrivilegeMoney() {
		return privilegeMoney;
	}

	public void setPrivilegeMoney(Double privilegeMoney) {
		this.privilegeMoney = privilegeMoney;
	}

	public String getDiscountPrivilege() {
		return discountPrivilege;
	}

	public void setDiscountPrivilege(String discountPrivilege) {
		this.discountPrivilege = discountPrivilege;
	}

	public String getDiscountPrivMon() {
		return discountPrivMon;
	}

	public void setDiscountPrivMon(String discountPrivMon) {
		this.discountPrivMon = discountPrivMon;
	}
}
