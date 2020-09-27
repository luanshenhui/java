package cn.com.cgbchina.rest.provider.vo.activity;

import java.io.Serializable;

import cn.com.cgbchina.rest.common.annotation.XMLNodeName;
import cn.com.cgbchina.rest.provider.vo.BaseEntityVO;

/**
 * MAL421 微信易信O2O0元秒杀商品详情查询
 * 
 * @author lizy 2016/4/28.
 */
public class WXYXo2oGoodsQueryReturnVO extends BaseEntityVO implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = -6321283461035360236L;
	@XMLNodeName(value = "goods_id")
	private String goodsId;
	@XMLNodeName(value = "goods_nm")
	private String goodsNm;
	@XMLNodeName(value = "goods_mid")
	private String goodsMid;
	@XMLNodeName(value = "goods_price")
	private String goodsPrice;
	@XMLNodeName(value = "goods_color")
	private String goodsColor;
	@XMLNodeName(value = "goods_size")
	private String goodsSize;
	@XMLNodeName(value = "goods_backlog")
	private String goodsBacklog;
	@XMLNodeName(value = "goods_detail_desc")
	private String goodsDetailDesc;
	@XMLNodeName(value = "payway_id_y")
	private String paywayIdY;
	@XMLNodeName(value = "picture_url")
	private String pictureUrl;
	@XMLNodeName(value = "begin_date")
	private String beginDate;
	@XMLNodeName(value = "end_date")
	private String endDate;
	@XMLNodeName(value = "begin_time")
	private String beginTime;
	@XMLNodeName(value = "end_time")
	private String endTime;

	@XMLNodeName(value = "begin_time2")
	private String beginTime2;

	@XMLNodeName(value = "end_time2")
	private String endTime2;
	@XMLNodeName(value = "goods_count")
	private String goodsCount;
	@XMLNodeName(value = "goods_count")
	private String goodsCount2;

	@XMLNodeName(value = "market_price")
	private String marketprice;
	@XMLNodeName(value = "act_frequency")
	private String actFrequency;
	@XMLNodeName(value = "buying_restrictions")
	private String buyingRestrictions;
	@XMLNodeName(value = "limited_number")
	private String limitedNumber;
	@XMLNodeName(value = "goods_desc")
	private String goodsDesc;
	@XMLNodeName(value = "source_id")
	private String sourceId;
	private String status;

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

	public String getGoodsMid() {
		return goodsMid;
	}

	public void setGoodsMid(String goodsMid) {
		this.goodsMid = goodsMid;
	}

	public String getGoodsPrice() {
		return goodsPrice;
	}

	public void setGoodsPrice(String goodsPrice) {
		this.goodsPrice = goodsPrice;
	}

	public String getGoodsColor() {
		return goodsColor;
	}

	public void setGoodsColor(String goodsColor) {
		this.goodsColor = goodsColor;
	}

	public String getGoodsSize() {
		return goodsSize;
	}

	public void setGoodsSize(String goodsSize) {
		this.goodsSize = goodsSize;
	}

	public String getGoodsBacklog() {
		return goodsBacklog;
	}

	public void setGoodsBacklog(String goodsBacklog) {
		this.goodsBacklog = goodsBacklog;
	}

	public String getGoodsDetailDesc() {
		return goodsDetailDesc;
	}

	public void setGoodsDetailDesc(String goodsDetailDesc) {
		this.goodsDetailDesc = goodsDetailDesc;
	}

	public String getPaywayIdY() {
		return paywayIdY;
	}

	public void setPaywayIdY(String paywayIdY) {
		this.paywayIdY = paywayIdY;
	}

	public String getPictureUrl() {
		return pictureUrl;
	}

	public void setPictureUrl(String pictureUrl) {
		this.pictureUrl = pictureUrl;
	}

	public String getBeginDate() {
		return beginDate;
	}

	public void setBeginDate(String beginDate) {
		this.beginDate = beginDate;
	}

	public String getEndDate() {
		return endDate;
	}

	public void setEndDate(String endDate) {
		this.endDate = endDate;
	}

	public String getBeginTime() {
		return beginTime;
	}

	public void setBeginTime(String beginTime) {
		this.beginTime = beginTime;
	}

	public String getEndTime() {
		return endTime;
	}

	public void setEndTime(String endTime) {
		this.endTime = endTime;
	}

	public String getBeginTime2() {
		return beginTime2;
	}

	public void setBeginTime2(String beginTime2) {
		this.beginTime2 = beginTime2;
	}

	public String getEndTime2() {
		return endTime2;
	}

	public void setEndTime2(String endTime2) {
		this.endTime2 = endTime2;
	}

	public String getGoodsCount() {
		return goodsCount;
	}

	public void setGoodsCount(String goodsCount) {
		this.goodsCount = goodsCount;
	}

	public String getGoodsCount2() {
		return goodsCount2;
	}

	public void setGoodsCount2(String goodsCount2) {
		this.goodsCount2 = goodsCount2;
	}

	public String getMarketprice() {
		return marketprice;
	}

	public void setMarketprice(String marketprice) {
		this.marketprice = marketprice;
	}

	public String getActFrequency() {
		return actFrequency;
	}

	public void setActFrequency(String actFrequency) {
		this.actFrequency = actFrequency;
	}

	public String getBuyingRestrictions() {
		return buyingRestrictions;
	}

	public void setBuyingRestrictions(String buyingRestrictions) {
		this.buyingRestrictions = buyingRestrictions;
	}

	public String getLimitedNumber() {
		return limitedNumber;
	}

	public void setLimitedNumber(String limitedNumber) {
		this.limitedNumber = limitedNumber;
	}

	public String getGoodsDesc() {
		return goodsDesc;
	}

	public void setGoodsDesc(String goodsDesc) {
		this.goodsDesc = goodsDesc;
	}

	public String getSourceId() {
		return sourceId;
	}

	public void setSourceId(String sourceId) {
		this.sourceId = sourceId;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

}
