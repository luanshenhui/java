package cn.com.cgbchina.rest.provider.model.order;

import java.io.Serializable;

import cn.com.cgbchina.rest.provider.model.BaseEntity;

/**
 * MAL308 订单查询(分期商城)
 * 
 * @author Lizy
 *
 */
public class StageMallOrdersInfoByAPP extends BaseEntity implements Serializable {
	/**
	 * 
	 */
	private static final long serialVersionUID = 3927786898361200729L;
	private String ordertypeId;
	private String orderId;
	private String stagesNum;
	private String singlePrice;
	private String perStage;
	private String jfType;
	private String singlePoint;
	private String totalPoint;
	private String goodsPrice;
	private String createDate;
	private String curStatusId;
	private String goodssendFlag;

	public String getOrdertypeId() {
		return ordertypeId;
	}

	public void setOrdertypeId(String ordertypeId) {
		this.ordertypeId = ordertypeId;
	}

	public String getOrderId() {
		return orderId;
	}

	public void setOrderId(String orderId) {
		this.orderId = orderId;
	}

	public String getStagesNum() {
		return stagesNum;
	}

	public void setStagesNum(String stagesNum) {
		this.stagesNum = stagesNum;
	}

	public String getSinglePrice() {
		return singlePrice;
	}

	public void setSinglePrice(String singlePrice) {
		this.singlePrice = singlePrice;
	}

	public String getPerStage() {
		return perStage;
	}

	public void setPerStage(String perStage) {
		this.perStage = perStage;
	}

	public String getJfType() {
		return jfType;
	}

	public void setJfType(String jfType) {
		this.jfType = jfType;
	}

	public String getSinglePoint() {
		return singlePoint;
	}

	public void setSinglePoint(String singlePoint) {
		this.singlePoint = singlePoint;
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

	public String getCreateDate() {
		return createDate;
	}

	public void setCreateDate(String createDate) {
		this.createDate = createDate;
	}

	public String getCurStatusId() {
		return curStatusId;
	}

	public void setCurStatusId(String curStatusId) {
		this.curStatusId = curStatusId;
	}

	public String getGoodssendFlag() {
		return goodssendFlag;
	}

	public void setGoodssendFlag(String goodssendFlag) {
		this.goodssendFlag = goodssendFlag;
	}

	public String getGoodsNm() {
		return goodsNm;
	}

	public void setGoodsNm(String goodsNm) {
		this.goodsNm = goodsNm;
	}

	public String getPictureUrl() {
		return pictureUrl;
	}

	public void setPictureUrl(String pictureUrl) {
		this.pictureUrl = pictureUrl;
	}

	public String getPayOn() {
		return payOn;
	}

	public void setPayOn(String payOn) {
		this.payOn = payOn;
	}

	public String getMarketPrice() {
		return marketPrice;
	}

	public void setMarketPrice(String marketPrice) {
		this.marketPrice = marketPrice;
	}

	public String getGoodsAttr1() {
		return goodsAttr1;
	}

	public void setGoodsAttr1(String goodsAttr1) {
		this.goodsAttr1 = goodsAttr1;
	}

	public String getGoodsColor() {
		return goodsColor;
	}

	public void setGoodsColor(String goodsColor) {
		this.goodsColor = goodsColor;
	}

	public String getGoodsAttr2() {
		return goodsAttr2;
	}

	public void setGoodsAttr2(String goodsAttr2) {
		this.goodsAttr2 = goodsAttr2;
	}

	public String getGoodsModel() {
		return goodsModel;
	}

	public void setGoodsModel(String goodsModel) {
		this.goodsModel = goodsModel;
	}

	public String getGoodsNum() {
		return goodsNum;
	}

	public void setGoodsNum(String goodsNum) {
		this.goodsNum = goodsNum;
	}

	public String getSourceId() {
		return sourceId;
	}

	public void setSourceId(String sourceId) {
		this.sourceId = sourceId;
	}

	public String getMailingNum() {
		return mailingNum;
	}

	public void setMailingNum(String mailingNum) {
		this.mailingNum = mailingNum;
	}

	public String getTradeSeqNo() {
		return tradeSeqNo;
	}

	public void setTradeSeqNo(String tradeSeqNo) {
		this.tradeSeqNo = tradeSeqNo;
	}

	public String getPrivilegeId() {
		return privilegeId;
	}

	public void setPrivilegeId(String privilegeId) {
		this.privilegeId = privilegeId;
	}

	public String getMerId() {
		return merId;
	}

	public void setMerId(String merId) {
		this.merId = merId;
	}

	public String getDiscountPrivMon() {
		return discountPrivMon;
	}

	public void setDiscountPrivMon(String discountPrivMon) {
		this.discountPrivMon = discountPrivMon;
	}

	public String getCreateTime() {
		return createTime;
	}

	public void setCreateTime(String createTime) {
		this.createTime = createTime;
	}

	public String getOrdermainId() {
		return ordermainId;
	}

	public void setOrdermainId(String ordermainId) {
		this.ordermainId = ordermainId;
	}

	public String getCardNo() {
		return cardNo;
	}

	public void setCardNo(String cardNo) {
		this.cardNo = cardNo;
	}

	public String getCardType() {
		return cardType;
	}

	public void setCardType(String cardType) {
		this.cardType = cardType;
	}

	public String getReceivedTime() {
		return receivedTime;
	}

	public void setReceivedTime(String receivedTime) {
		this.receivedTime = receivedTime;
	}

	private String goodsNm;
	private String pictureUrl;
	private String payOn;
	private String marketPrice;
	private String goodsAttr1;
	private String goodsColor;
	private String goodsAttr2;
	private String goodsModel;
	private String goodsNum;
	private String sourceId;
	private String mailingNum;
	private String tradeSeqNo;
	private String privilegeId;
	private String merId;
	private String discountPrivMon;
	private String createTime;
	private String ordermainId;
	private String cardNo;
	private String cardType;
	private String receivedTime;

}
