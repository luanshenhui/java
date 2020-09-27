package cn.com.cgbchina.rest.provider.vo.order;

import java.io.Serializable;

import javax.validation.constraints.NotNull;

import cn.com.cgbchina.rest.common.annotation.XMLNodeName;
import cn.com.cgbchina.rest.provider.vo.BaseQueryEntityVO;

/**
 * @author lizy MAL104 CC/IVR积分商城下单
 */
public class CCAndIVRIntergalOrderVO extends BaseQueryEntityVO implements Serializable {
	private static final long serialVersionUID = 3401261370298282387L;
	@NotNull
	private String custName;
	@NotNull
	private String deliveryName;
	@NotNull
	private String deliveryMoblie;
	@NotNull
	private String deliveryPhone;
	@NotNull
	private String deliveryAddr;
	@NotNull
	private String deliveryPost;
	@NotNull
	private String acceptedNo;
	@NotNull
	private String orderType;
	@NotNull
	private String ivrFlag;
	@NotNull
	private String cardNo;
	@NotNull
	private String formatId;
	@NotNull
	private String intergralType;
	@NotNull
	private String intergralNo;
	@NotNull
	private String goodsPrice;
	@NotNull
	private String validDate;
	@NotNull
	private String goodsId;
	@NotNull
	private String paywayId;
	@NotNull
	private String goodsNo;
	@NotNull
	private String contIdCard;
	@XMLNodeName(value = "force_buy")
	private String forceBuy;
	@XMLNodeName(value = "entry_card")
	private String entryCard;
	@XMLNodeName(value = "virtual_member_id")
	private String virtualMemberId;
	@XMLNodeName(value = "virtual_member_nm")
	private String virtualMemberNm;
	@XMLNodeName(value = "v_aviation_type")
	private String vAviationType;
	private String tradeDesc;
	@XMLNodeName(value = "ordermain_desc")
	private String ordermainDesc;
	private String desc1;
	private String desc2;
	private String desc3;

	public String getCustName() {
		return custName;
	}

	public void setCustName(String custName) {
		this.custName = custName;
	}

	public String getDeliveryName() {
		return deliveryName;
	}

	public void setDeliveryName(String deliveryName) {
		this.deliveryName = deliveryName;
	}

	public String getDeliveryMoblie() {
		return deliveryMoblie;
	}

	public void setDeliveryMoblie(String deliveryMoblie) {
		this.deliveryMoblie = deliveryMoblie;
	}

	public String getDeliveryPhone() {
		return deliveryPhone;
	}

	public void setDeliveryPhone(String deliveryPhone) {
		this.deliveryPhone = deliveryPhone;
	}

	public String getDeliveryAddr() {
		return deliveryAddr;
	}

	public void setDeliveryAddr(String deliveryAddr) {
		this.deliveryAddr = deliveryAddr;
	}

	public String getDeliveryPost() {
		return deliveryPost;
	}

	public void setDeliveryPost(String deliveryPost) {
		this.deliveryPost = deliveryPost;
	}

	public String getAcceptedNo() {
		return acceptedNo;
	}

	public void setAcceptedNo(String acceptedNo) {
		this.acceptedNo = acceptedNo;
	}

	public String getOrderType() {
		return orderType;
	}

	public void setOrderType(String orderType) {
		this.orderType = orderType;
	}

	public String getIvrFlag() {
		return ivrFlag;
	}

	public void setIvrFlag(String ivrFlag) {
		this.ivrFlag = ivrFlag;
	}

	public String getCardNo() {
		return cardNo;
	}

	public void setCardNo(String cardNo) {
		this.cardNo = cardNo;
	}

	public String getFormatId() {
		return formatId;
	}

	public void setFormatId(String formatId) {
		this.formatId = formatId;
	}

	public String getIntergralType() {
		return intergralType;
	}

	public void setIntergralType(String intergralType) {
		this.intergralType = intergralType;
	}

	public String getIntergralNo() {
		return intergralNo;
	}

	public void setIntergralNo(String intergralNo) {
		this.intergralNo = intergralNo;
	}

	public String getGoodsPrice() {
		return goodsPrice;
	}

	public void setGoodsPrice(String goodsPrice) {
		this.goodsPrice = goodsPrice;
	}

	public String getValidDate() {
		return validDate;
	}

	public void setValidDate(String validDate) {
		this.validDate = validDate;
	}

	public String getGoodsId() {
		return goodsId;
	}

	public void setGoodsId(String goodsId) {
		this.goodsId = goodsId;
	}

	public String getPaywayId() {
		return paywayId;
	}

	public void setPaywayId(String paywayId) {
		this.paywayId = paywayId;
	}

	public String getGoodsNo() {
		return goodsNo;
	}

	public void setGoodsNo(String goodsNo) {
		this.goodsNo = goodsNo;
	}

	public String getContIdCard() {
		return contIdCard;
	}

	public void setContIdCard(String contIdCard) {
		this.contIdCard = contIdCard;
	}

	public String getForceBuy() {
		return forceBuy;
	}

	public void setForceBuy(String forceBuy) {
		this.forceBuy = forceBuy;
	}

	public String getEntryCard() {
		return entryCard;
	}

	public void setEntryCard(String entryCard) {
		this.entryCard = entryCard;
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

	public String getTradeDesc() {
		return tradeDesc;
	}

	public void setTradeDesc(String tradeDesc) {
		this.tradeDesc = tradeDesc;
	}

	public String getOrdermainDesc() {
		return ordermainDesc;
	}

	public void setOrdermainDesc(String ordermainDesc) {
		this.ordermainDesc = ordermainDesc;
	}

	public String getDesc1() {
		return desc1;
	}

	public void setDesc1(String desc1) {
		this.desc1 = desc1;
	}

	public String getDesc2() {
		return desc2;
	}

	public void setDesc2(String desc2) {
		this.desc2 = desc2;
	}

	public String getDesc3() {
		return desc3;
	}

	public void setDesc3(String desc3) {
		this.desc3 = desc3;
	}
}
