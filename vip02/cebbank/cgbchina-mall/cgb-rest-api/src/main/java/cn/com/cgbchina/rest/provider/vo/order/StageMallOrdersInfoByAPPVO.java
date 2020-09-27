package cn.com.cgbchina.rest.provider.vo.order;

import java.io.Serializable;

import cn.com.cgbchina.rest.common.annotation.XMLNodeName;
import cn.com.cgbchina.rest.provider.vo.BaseEntityVO;

/**
 * MAL308 订单查询(分期商城)
 * 
 * @author Lizy
 *
 */
public class StageMallOrdersInfoByAPPVO extends BaseEntityVO implements Serializable {
	/**
	 * 
	 */
	private static final long serialVersionUID = 3927786898361200729L;
	@XMLNodeName(value = "ordertype_id")
	private String ordertypeId;
	@XMLNodeName(value = "order_id")
	private String orderId;
	@XMLNodeName(value = "stages_num")
	private String stagesNum;
	@XMLNodeName(value = "single_price")
	private String singlePrice;
	@XMLNodeName(value = "per_stage")
	private String perStage;
	@XMLNodeName(value = "jf_type")
	private String jfType;
	@XMLNodeName(value = "single_point")
	private String singlePoint;
	@XMLNodeName(value = "total_point")
	private String totalPoint;
	@XMLNodeName(value = "goods_price")
	private String goodsPrice;
	@XMLNodeName(value = "create_date")
	private String createDate;
	@XMLNodeName(value = "cur_status_id")
	private String curStatusId;
	@XMLNodeName(value = "goodssend_flag")
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

	@XMLNodeName(value = "goods_nm")
	private String goodsNm;
	@XMLNodeName(value = "picture_url")
	private String pictureUrl;
	@XMLNodeName(value = "pay_on")
	private String payOn;
	@XMLNodeName(value = "market_price")
	private String marketPrice;
	@XMLNodeName(value = "goods_attr1")
	private String goodsAttr1;
	@XMLNodeName(value = "goods_color")
	private String goodsColor;
	@XMLNodeName(value = "goods_attr2")
	private String goodsAttr2;
	@XMLNodeName(value = "GOODS_MODEL")
	private String goodsModel;
	@XMLNodeName(value = "GOODS_NUM")
	private String goodsNum;
	@XMLNodeName(value = "SOURCE_ID")
	private String sourceId;
	@XMLNodeName(value = "mailing_num")
	private String mailingNum;
	private String tradeSeqNo;
	private String privilegeId;
	@XMLNodeName(value = "mer_id")
	private String merId;
	private String discountPrivMon;
	@XMLNodeName(value = "create_time")
	private String createTime;
	@XMLNodeName(value = "ordermain_id")
	private String ordermainId;
	private String cardNo;
	private String cardType;
	@XMLNodeName(value = "RECEIVED_TIME")
	private String receivedTime;

}
