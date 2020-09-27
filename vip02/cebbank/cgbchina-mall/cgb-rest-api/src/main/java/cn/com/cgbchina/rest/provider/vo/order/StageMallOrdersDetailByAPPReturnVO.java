package cn.com.cgbchina.rest.provider.vo.order;

import java.io.Serializable;

import cn.com.cgbchina.rest.common.annotation.XMLNodeName;
import cn.com.cgbchina.rest.provider.vo.BaseEntityVO;

/**
 * MAL309 订单详细信息查询(分期商城)App
 * 
 * @author Lizy
 *
 */
public class StageMallOrdersDetailByAPPReturnVO extends BaseEntityVO implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1098704262936836563L;
	@XMLNodeName(value = "order_id")
	private String orderId;
	@XMLNodeName(value = "cur_status_id")
	private String curStatusId;
	private String ordertypeId;
	@XMLNodeName(value = "goodssend_flag")
	private String goodssendFlag;
	@XMLNodeName(value = "create_date")
	private String createDate;
	@XMLNodeName(value = "create_time")
	private String createTime;
	@XMLNodeName(value = "goodssend_date")
	private String goodsSendDate;
	@XMLNodeName(value = "goodssend_time")
	private String goodsSendTime;
	@XMLNodeName(value = "send_time")
	private String sendTime;
	@XMLNodeName(value = "is_invoice")
	private String isInvoice;
	@XMLNodeName(value = "invoice_type")
	private String invoiceType;
	private String invoice;
	@XMLNodeName(value = "invoice_content")
	private String invoiceContent;
	@XMLNodeName(value = "ordermain_desc")
	private String ordermainDesc;
	@XMLNodeName(value = "csg_address")
	private String csgAddress;
	@XMLNodeName(value = "csg_province")
	private String csgProvince;
	@XMLNodeName(value = "csg_city")
	private String csgCity;
	@XMLNodeName(value = "csg_borough")
	private String csgBorough;
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
	@XMLNodeName(value = "single_price")
	private String singlePrice;
	@XMLNodeName(value = "stages_num")
	private String stagesNum;
	@XMLNodeName(value = "per_stage")
	private String perStage;
	private String privilegeId;
	private String privilegeName;
	private Double privilegeMoney;
	private String discountPrivilege;
	private String discountPrivMon;
	@XMLNodeName(value = "single_bonus")
	private String singleBonus;
	@XMLNodeName(value = "goods_xid")
	private String goodsXid;
	@XMLNodeName(value = "jf_type")
	private String jfType;
	@XMLNodeName(value = "total_point")
	private String totalPoint;
	@XMLNodeName(value = "goods_price")
	private String goodsPrice;
	@XMLNodeName(value = "goods_size")
	private String goodsSize;
	@XMLNodeName(value = "goods_color")
	private String goodsColor;
	@XMLNodeName(value = "vendor_role")
	private String vendorRole;
	@XMLNodeName(value = "mailing_num")
	private String mailingNum;
	@XMLNodeName(value = "service_url")
	private String serviceUrl;
	private String operTime;
	private String orderComments;
	private String operateName;
	@XMLNodeName(value = "picture_url")
	private String pictureUrl;
	@XMLNodeName(value = "VENDOR_FNM")
	private String vendorFnm;
	private String cardNo;
	private String orderMainId;
	@XMLNodeName(value = "vendor_phone")
	private String vendorPhone;
	@XMLNodeName(value = "mainmer_id")
	private String mainmerId;
	private String tradeSeqNo;
	@XMLNodeName(value = "mer_id")
	private String merId;
	private String cardtype;
	@XMLNodeName(value = "RECEIVED_TIME")
	private String ReceivedTime;
	@XMLNodeName(value = "GOODS_MODEL")
	private String GoodsModel;
	@XMLNodeName(value = "goods_attr1")
	private Double goodsAttr1;
	@XMLNodeName(value = "goods_attr2")
	private String goodsAttr2;

	public String getGoodsSendDate() {
		return goodsSendDate;
	}

	public void setGoodsSendDate(String goodsSendDate) {
		this.goodsSendDate = goodsSendDate;
	}

	public String getGoodsSendTime() {
		return goodsSendTime;
	}

	public void setGoodsSendTime(String goodsSendTime) {
		this.goodsSendTime = goodsSendTime;
	}

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

	public String getOrdertypeId() {
		return ordertypeId;
	}

	public void setOrdertypeId(String ordertypeId) {
		this.ordertypeId = ordertypeId;
	}

	public String getCreateDate() {
		return createDate;
	}

	public void setCreateDate(String createDate) {
		this.createDate = createDate;
	}

	public String getCreateTime() {
		return createTime;
	}

	public void setCreateTime(String createTime) {
		this.createTime = createTime;
	}

	public String getSendTime() {
		return sendTime;
	}

	public void setSendTime(String sendTime) {
		this.sendTime = sendTime;
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

	public String getCsgAddress() {
		return csgAddress;
	}

	public void setCsgAddress(String csgAddress) {
		this.csgAddress = csgAddress;
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

	public String getSingleBonus() {
		return singleBonus;
	}

	public void setSingleBonus(String singleBonus) {
		this.singleBonus = singleBonus;
	}

	public String getGoodsXid() {
		return goodsXid;
	}

	public void setGoodsXid(String goodsXid) {
		this.goodsXid = goodsXid;
	}

	public String getJfType() {
		return jfType;
	}

	public void setJfType(String jfType) {
		this.jfType = jfType;
	}

	public String getTotalPoint() {
		return totalPoint;
	}

	public void setTotalPoint(String totalPoint) {
		this.totalPoint = totalPoint;
	}

	public String getGoodsPrice() {
		return goodsPrice;
	}

	public void setGoodsPrice(String goodsPrice) {
		this.goodsPrice = goodsPrice;
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

	public String getVendorRole() {
		return vendorRole;
	}

	public void setVendorRole(String vendorRole) {
		this.vendorRole = vendorRole;
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

	public String getPictureUrl() {
		return pictureUrl;
	}

	public void setPictureUrl(String pictureUrl) {
		this.pictureUrl = pictureUrl;
	}

	public String getVendorFnm() {
		return vendorFnm;
	}

	public void setVendorFnm(String vendorFnm) {
		this.vendorFnm = vendorFnm;
	}

	public String getCardNo() {
		return cardNo;
	}

	public void setCardNo(String cardNo) {
		this.cardNo = cardNo;
	}

	public String getOrderMainId() {
		return orderMainId;
	}

	public void setOrderMainId(String orderMainId) {
		this.orderMainId = orderMainId;
	}

	public String getVendorPhone() {
		return vendorPhone;
	}

	public void setVendorPhone(String vendorPhone) {
		this.vendorPhone = vendorPhone;
	}

	public String getMainmerId() {
		return mainmerId;
	}

	public void setMainmerId(String mainmerId) {
		this.mainmerId = mainmerId;
	}

	public String getTradeSeqNo() {
		return tradeSeqNo;
	}

	public void setTradeSeqNo(String tradeSeqNo) {
		this.tradeSeqNo = tradeSeqNo;
	}

	public String getMerId() {
		return merId;
	}

	public void setMerId(String merId) {
		this.merId = merId;
	}

	public String getCardtype() {
		return cardtype;
	}

	public void setCardtype(String cardtype) {
		this.cardtype = cardtype;
	}

	public String getReceivedTime() {
		return ReceivedTime;
	}

	public void setReceivedTime(String receivedTime) {
		ReceivedTime = receivedTime;
	}

	public String getGoodsModel() {
		return GoodsModel;
	}

	public void setGoodsModel(String goodsModel) {
		GoodsModel = goodsModel;
	}

	public Double getGoodsAttr1() {
		return goodsAttr1;
	}

	public void setGoodsAttr1(Double goodsAttr1) {
		this.goodsAttr1 = goodsAttr1;
	}

	public String getGoodsAttr2() {
		return goodsAttr2;
	}

	public void setGoodsAttr2(String goodsAttr2) {
		this.goodsAttr2 = goodsAttr2;
	}

}
