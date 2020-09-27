package cn.com.cgbchina.rest.provider.vo.order;

import javax.validation.constraints.NotNull;

import cn.com.cgbchina.rest.common.annotation.XMLNodeName;
import cn.com.cgbchina.rest.provider.vo.BaseQueryEntityVO;

/**
 * MAL401 短信下单接口
 * 
 * @author lizy 2016/4/28.
 */
public class SMSOrderAddVO extends BaseQueryEntityVO {

	/**
	 * 
	 */
	private static final long serialVersionUID = 6526260626509192908L;
	@NotNull
	private String custName;
	@NotNull
	private String contIdCard;
	@NotNull
	private String contIdType;
	@NotNull
	private String csgName;
	@NotNull
	private String csgMoblie;
	private String csgPhone;
	@NotNull
	private String csgProvince;
	@NotNull
	private String csgCity;
	private String csgBorough;
	@NotNull
	private String csgAddress;
	@NotNull
	private String deliveryPost;
	@NotNull
	private String cardNo;
	private String formatId;
	private String intergralType;
	private String jfTypeName;
	@NotNull
	private String validDate;
	@NotNull
	private String sendTime;
	private String ordermainDesc;
	@NotNull
	@XMLNodeName(value = "is_money")
	private String isMoney;
	@NotNull
	@XMLNodeName(value = "is_merge")
	private String isMerge;
	@NotNull
	private String goodsId;
	@NotNull
	private String goodsNm;
	@NotNull
	private String businessType;
	@NotNull
	@XMLNodeName(value = "VOUCHER_MONEY")
	private String voucherMoney;

	//配合信用卡大机改造新增字段
	private String tradeChannel;
	private String tradeSource;
	private String bizSight;
	private String sorceSenderNo;
	private String operatorId;

	public String getCustName() {
		return custName;
	}

	public void setCustName(String custName) {
		this.custName = custName;
	}

	public String getContIdCard() {
		return contIdCard;
	}

	public void setContIdCard(String contIdCard) {
		this.contIdCard = contIdCard;
	}

	public String getContIdType() {
		return contIdType;
	}

	public void setContIdType(String contIdType) {
		this.contIdType = contIdType;
	}

	public String getCsgName() {
		return csgName;
	}

	public void setCsgName(String csgName) {
		this.csgName = csgName;
	}

	public String getCsgMoblie() {
		return csgMoblie;
	}

	public void setCsgMoblie(String csgMoblie) {
		this.csgMoblie = csgMoblie;
	}

	public String getCsgPhone() {
		return csgPhone;
	}

	public void setCsgPhone(String csgPhone) {
		this.csgPhone = csgPhone;
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

	public String getCsgAddress() {
		return csgAddress;
	}

	public void setCsgAddress(String csgAddress) {
		this.csgAddress = csgAddress;
	}

	public String getDeliveryPost() {
		return deliveryPost;
	}

	public void setDeliveryPost(String deliveryPost) {
		this.deliveryPost = deliveryPost;
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

	public String getJfTypeName() {
		return jfTypeName;
	}

	public void setJfTypeName(String jfTypeName) {
		this.jfTypeName = jfTypeName;
	}

	public String getValidDate() {
		return validDate;
	}

	public void setValidDate(String validDate) {
		this.validDate = validDate;
	}

	public String getSendTime() {
		return sendTime;
	}

	public void setSendTime(String sendTime) {
		this.sendTime = sendTime;
	}

	public String getOrdermainDesc() {
		return ordermainDesc;
	}

	public void setOrdermainDesc(String ordermainDesc) {
		this.ordermainDesc = ordermainDesc;
	}

	public String getIsMoney() {
		return isMoney;
	}

	public void setIsMoney(String isMoney) {
		this.isMoney = isMoney;
	}

	public String getIsMerge() {
		return isMerge;
	}

	public void setIsMerge(String isMerge) {
		this.isMerge = isMerge;
	}

	public String getGoodsId() {
		return goodsId;
	}

	public void setGoodsId(String goodsId) {
		this.goodsId = goodsId;
	}

	public String getGoodsNm() {
		return goodsNm;
	}

	public void setGoodsNm(String goodsNm) {
		this.goodsNm = goodsNm;
	}

	public String getBusinessType() {
		return businessType;
	}

	public void setBusinessType(String businessType) {
		this.businessType = businessType;
	}

	public String getVoucherMoney() {
		return voucherMoney;
	}

	public void setVoucherMoney(String voucherMoney) {
		this.voucherMoney = voucherMoney;
	}

	public String getTradeChannel() {
		return tradeChannel;
	}

	public void setTradeChannel(String tradeChannel) {
		this.tradeChannel = tradeChannel;
	}

	public String getTradeSource() {
		return tradeSource;
	}

	public void setTradeSource(String tradeSource) {
		this.tradeSource = tradeSource;
	}

	public String getBizSight() {
		return bizSight;
	}

	public void setBizSight(String bizSight) {
		this.bizSight = bizSight;
	}

	public String getSorceSenderNo() {
		return sorceSenderNo;
	}

	public void setSorceSenderNo(String sorceSenderNo) {
		this.sorceSenderNo = sorceSenderNo;
	}

	public String getOperatorId() {
		return operatorId;
	}

	public void setOperatorId(String operatorId) {
		this.operatorId = operatorId;
	}
}
