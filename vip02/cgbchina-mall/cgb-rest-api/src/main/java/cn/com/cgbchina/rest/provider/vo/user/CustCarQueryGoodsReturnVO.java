package cn.com.cgbchina.rest.provider.vo.user;

import java.io.Serializable;

import cn.com.cgbchina.rest.common.annotation.AllowNull;
import cn.com.cgbchina.rest.common.annotation.XMLNodeName;

/**
 * MAL305 查询购物车(分期商城)
 * 
 * @author lizy 2016/4/28.
 */
public class CustCarQueryGoodsReturnVO implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 8425890370087339605L;
	/**
	 * 
	 */
	private String id;
	@XMLNodeName(value = "cust_id")
	private String custId;
	@XMLNodeName(value = "goods_id")
	private String goodsId;
	@XMLNodeName(value = "goods_mid")
	private String goodsMid;
	@XMLNodeName(value = "goods_oid")
	private String goodsOid;
	@XMLNodeName(value = "goods_xid")
	private String goodsXid;
	@XMLNodeName(value = "stages_num")
	private String stagesNum;
	@XMLNodeName(value = "goods_nm")
	private String goodsNm;
	@XMLNodeName(value = "goods_price_y")
	private String goodsPriceY;
	@XMLNodeName(value = "goods_price_f")
	private String goodsPriceF;
	@XMLNodeName(value = "jf_type")
	private String jfType;
	@XMLNodeName(value = "goods_price")
	private String goodsPrice;
	@XMLNodeName(value = "goods_point")
	private String goodsPoint;
	@XMLNodeName(value = "single_point")
	private String singlePoint;
	@XMLNodeName(value = "payway_code")
	private String paywayCode;
	@XMLNodeName(value = "goods_payway_id")
	private String goodsPaywayId;
	@XMLNodeName(value = "alert_num")
	private String alertNum;
	@XMLNodeName(value = "goods_backlog")
	private String goodsBacklog;
	@XMLNodeName(value = "goods_num")
	private String goodsNum;
	@XMLNodeName(value = "ordertype_id")
	private String ordertypeId;
	@XMLNodeName(value = "add_date")
	private String addDate;
	@XMLNodeName(value = "add_time")
	private String addTime;

	@AllowNull
	@XMLNodeName(value = "picture_url")
	private String pictureUrl;

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getCustId() {
		return custId;
	}

	public void setCustId(String custId) {
		this.custId = custId;
	}

	public String getGoodsId() {
		return goodsId;
	}

	public void setGoodsId(String goodsId) {
		this.goodsId = goodsId;
	}

	public String getGoodsMid() {
		return goodsMid;
	}

	public void setGoodsMid(String goodsMid) {
		this.goodsMid = goodsMid;
	}

	public String getGoodsOid() {
		return goodsOid;
	}

	public void setGoodsOid(String goodsOid) {
		this.goodsOid = goodsOid;
	}

	public String getGoodsXid() {
		return goodsXid;
	}

	public void setGoodsXid(String goodsXid) {
		this.goodsXid = goodsXid;
	}

	public String getStagesNum() {
		return stagesNum;
	}

	public void setStagesNum(String stagesNum) {
		this.stagesNum = stagesNum;
	}

	public String getGoodsNm() {
		return goodsNm;
	}

	public void setGoodsNm(String goodsNm) {
		this.goodsNm = goodsNm;
	}

	public String getGoodsPriceY() {
		return goodsPriceY;
	}

	public void setGoodsPriceY(String goodsPriceY) {
		this.goodsPriceY = goodsPriceY;
	}

	public String getGoodsPriceF() {
		return goodsPriceF;
	}

	public void setGoodsPriceF(String goodsPriceF) {
		this.goodsPriceF = goodsPriceF;
	}

	public String getJfType() {
		return jfType;
	}

	public void setJfType(String jfType) {
		this.jfType = jfType;
	}

	public String getGoodsPrice() {
		return goodsPrice;
	}

	public void setGoodsPrice(String goodsPrice) {
		this.goodsPrice = goodsPrice;
	}

	public String getGoodsPoint() {
		return goodsPoint;
	}

	public void setGoodsPoint(String goodsPoint) {
		this.goodsPoint = goodsPoint;
	}

	public String getSinglePoint() {
		return singlePoint;
	}

	public void setSinglePoint(String singlePoint) {
		this.singlePoint = singlePoint;
	}

	public String getPaywayCode() {
		return paywayCode;
	}

	public void setPaywayCode(String paywayCode) {
		this.paywayCode = paywayCode;
	}

	public String getGoodsPaywayId() {
		return goodsPaywayId;
	}

	public void setGoodsPaywayId(String goodsPaywayId) {
		this.goodsPaywayId = goodsPaywayId;
	}

	public String getAlertNum() {
		return alertNum;
	}

	public void setAlertNum(String alertNum) {
		this.alertNum = alertNum;
	}

	public String getGoodsBacklog() {
		return goodsBacklog;
	}

	public void setGoodsBacklog(String goodsBacklog) {
		this.goodsBacklog = goodsBacklog;
	}

	public String getGoodsNum() {
		return goodsNum;
	}

	public void setGoodsNum(String goodsNum) {
		this.goodsNum = goodsNum;
	}

	public String getOrdertypeId() {
		return ordertypeId;
	}

	public void setOrdertypeId(String ordertypeId) {
		this.ordertypeId = ordertypeId;
	}

	public String getAddDate() {
		return addDate;
	}

	public void setAddDate(String addDate) {
		this.addDate = addDate;
	}

	public String getAddTime() {
		return addTime;
	}

	public void setAddTime(String addTime) {
		this.addTime = addTime;
	}

	public String getPictureUrl() {
		return pictureUrl;
	}

	public void setPictureUrl(String pictureUrl) {
		this.pictureUrl = pictureUrl;
	}

}
