package cn.com.cgbchina.rest.provider.model.order;

import cn.com.cgbchina.rest.provider.model.BaseQueryEntity;

/**
 * MAL401 短信下单接口
 * 
 * @author lizy 2016/4/28.
 */
public class SMSOrderAdd extends BaseQueryEntity {

	/**
	 * 
	 */
	private static final long serialVersionUID = 6526260626509192908L;
	private String custName;
	private String contIdCard;
	private String contIdType;
	private String csgName;
	private String csgMoblie;
	private String csgPhone;
	private String csgProvince;
	private String csgCity;
	private String csgBorough;
	private String csgAddress;
	private String deliveryPost;
	private String cardNo;
	private String formatId;
	private String intergralType;
	private String jfTypeName;
	private String validDate;
	private String sendTime;
	private String ordermainDesc;
	private String isMoney;
	private String isMerge;
	private String goodsId;
	private String goodsNm;
	private String businessType;
	private String voucherMoney;

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

}
