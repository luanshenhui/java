package cn.com.cgbchina.rest.provider.vo.order;

import java.io.Serializable;

/**
 * 微信下单vo
 */
public class WeChatVo  implements Serializable {
	private static final long serialVersionUID = 4232109310545743997L;
	private String tradeChannel;//交易渠道 行内最前端系统
	private String tradeSource;//交易来源 行内最前端系统
	private String bizSight;//业务场景 常规业务：00
	private String sorceSenderNo;//源发起方流水
	private String operatorId;//源发起方流水
	private String channelSN;//渠道 微信广发银行：WX；微信信用卡中心：WS；易信广发银行：YX；易信信用卡中心：YS
	private String custName;//客户姓名
	private String contIdCard;//证件号码
	private String contIdType;//证件类型
	private String csgName;//收货人姓名
	private String csgMoblie;//收货人手机
	private String csgPhone;//收货人固话
	private String csgProvince;//省
	private String csgCity;//市
	private String csgBorough;//区
	private String csgAddress;//街道详细地址
	private String deliveryPost;//邮政编码
	private String cardNo;//卡号
	private String formatId;//卡板
	private String intergralType;//积分类型
	private String jfTypeName;//积分类型中文名称
	private String validDate;//卡有效期
	private String sendTime;//送货时间(默认选取01) 01: 工作日、双休日与假日均可送货 02: 只有工作日送货（双休日、假日不用送） 03: 只有双休日、假日送货（工作日不用送货）
	private String ordermainDesc;//备注
	private String is_money;//是否积分+现金支付 0:是  1:否
	private String is_merge;//是否合并支付 0:合并  1:非合并（默认） 
	private String goods_xid;//商品编码 5位
	private String goodsNm;//商品数量 2位
	private String orderMainId ;//大订单号

	public String getBizSight() {
		return bizSight;
	}
	public void setBizSight(String bizSight) {
		this.bizSight = bizSight;
	}
	public String getCardNo() {
		return cardNo;
	}
	public void setCardNo(String cardNo) {
		this.cardNo = cardNo;
	}
	public String getChannelSN() {
		return channelSN;
	}
	public void setChannelSN(String channelSN) {
		this.channelSN = channelSN;
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
	public String getCsgAddress() {
		return csgAddress;
	}
	public void setCsgAddress(String csgAddress) {
		this.csgAddress = csgAddress;
	}
	public String getCsgBorough() {
		return csgBorough;
	}
	public void setCsgBorough(String csgBorough) {
		this.csgBorough = csgBorough;
	}
	public String getCsgCity() {
		return csgCity;
	}
	public void setCsgCity(String csgCity) {
		this.csgCity = csgCity;
	}
	public String getCsgMoblie() {
		return csgMoblie;
	}
	public void setCsgMoblie(String csgMoblie) {
		this.csgMoblie = csgMoblie;
	}
	public String getCsgName() {
		return csgName;
	}
	public void setCsgName(String csgName) {
		this.csgName = csgName;
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
	public String getCustName() {
		return custName;
	}
	public void setCustName(String custName) {
		this.custName = custName;
	}
	public String getDeliveryPost() {
		return deliveryPost;
	}
	public void setDeliveryPost(String deliveryPost) {
		this.deliveryPost = deliveryPost;
	}
	public String getFormatId() {
		return formatId;
	}
	public void setFormatId(String formatId) {
		this.formatId = formatId;
	}
	public String getGoods_xid() {
		return goods_xid;
	}
	public void setGoods_xid(String goods_xid) {
		this.goods_xid = goods_xid;
	}
	public String getGoodsNm() {
		return goodsNm;
	}
	public void setGoodsNm(String goodsNm) {
		this.goodsNm = goodsNm;
	}
	public String getIntergralType() {
		return intergralType;
	}
	public void setIntergralType(String intergralType) {
		this.intergralType = intergralType;
	}
	public String getIs_merge() {
		return is_merge;
	}
	public void setIs_merge(String is_merge) {
		this.is_merge = is_merge;
	}
	public String getIs_money() {
		return is_money;
	}
	public void setIs_money(String is_money) {
		this.is_money = is_money;
	}
	public String getJfTypeName() {
		return jfTypeName;
	}
	public void setJfTypeName(String jfTypeName) {
		this.jfTypeName = jfTypeName;
	}
	public String getOperatorId() {
		return operatorId;
	}
	public void setOperatorId(String operatorId) {
		this.operatorId = operatorId;
	}
	public String getOrdermainDesc() {
		return ordermainDesc;
	}
	public void setOrdermainDesc(String ordermainDesc) {
		this.ordermainDesc = ordermainDesc;
	}
	public String getSendTime() {
		return sendTime;
	}
	public void setSendTime(String sendTime) {
		this.sendTime = sendTime;
	}
	public String getSorceSenderNo() {
		return sorceSenderNo;
	}
	public void setSorceSenderNo(String sorceSenderNo) {
		this.sorceSenderNo = sorceSenderNo;
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
	public String getValidDate() {
		return validDate;
	}
	public void setValidDate(String validDate) {
		this.validDate = validDate;
	}
	public String getOrderMainId() {
		return orderMainId;
	}
	public void setOrderMainId(String orderMainId) {
		this.orderMainId = orderMainId;
	}

}
