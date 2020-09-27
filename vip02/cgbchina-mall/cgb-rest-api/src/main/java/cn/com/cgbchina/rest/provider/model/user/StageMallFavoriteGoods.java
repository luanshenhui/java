package cn.com.cgbchina.rest.provider.model.user;

import java.io.Serializable;

import cn.com.cgbchina.rest.provider.model.BaseEntity;

/**
 * MAL302 查询收藏商品(分期商城) 的商品信息
 * 
 * @author lizy 2016/4/28.
 */
public class StageMallFavoriteGoods extends BaseEntity implements Serializable {
	private static final long serialVersionUID = -1117784758756142180L;
	private String custId;
	private String id;
	private String goodsId;
	private String goodsNm;
	private String ordertypeId;
	private String goodsPriceY;
	private String goodsPriceF;
	private String goodsType;
	private String jpPricePayid;
	private String jpPrice;
	private String tzPricePayid;
	private String tzPrice;
	private String dzPricePayid;
	private String dzPrice;
	private String vipPricePayid;
	private String vipPrice;
	private String brhPricePayid;
	private String brhPrice;
	private String jfxjPricePayid;
	private String jfPart;
	private String xjPart;
	private String alertNum;
	private String goodsBacklog;
	private String paywayIdY;
	private String stagesNum;
	private String paywayIdF;
	private String doDate;
	private String doTime;
	private String favoriteDesc;
	private String pictureUrl;
	private String status;

	public String getCustId() {
		return custId;
	}

	public void setCustId(String custId) {
		this.custId = custId;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
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

	public String getOrdertypeId() {
		return ordertypeId;
	}

	public void setOrdertypeId(String ordertypeId) {
		this.ordertypeId = ordertypeId;
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

	public String getGoodsType() {
		return goodsType;
	}

	public void setGoodsType(String goodsType) {
		this.goodsType = goodsType;
	}

	public String getJpPricePayid() {
		return jpPricePayid;
	}

	public void setJpPricePayid(String jpPricePayid) {
		this.jpPricePayid = jpPricePayid;
	}

	public String getJpPrice() {
		return jpPrice;
	}

	public void setJpPrice(String jpPrice) {
		this.jpPrice = jpPrice;
	}

	public String getTzPricePayid() {
		return tzPricePayid;
	}

	public void setTzPricePayid(String tzPricePayid) {
		this.tzPricePayid = tzPricePayid;
	}

	public String getTzPrice() {
		return tzPrice;
	}

	public void setTzPrice(String tzPrice) {
		this.tzPrice = tzPrice;
	}

	public String getDzPricePayid() {
		return dzPricePayid;
	}

	public void setDzPricePayid(String dzPricePayid) {
		this.dzPricePayid = dzPricePayid;
	}

	public String getDzPrice() {
		return dzPrice;
	}

	public void setDzPrice(String dzPrice) {
		this.dzPrice = dzPrice;
	}

	public String getVipPricePayid() {
		return vipPricePayid;
	}

	public void setVipPricePayid(String vipPricePayid) {
		this.vipPricePayid = vipPricePayid;
	}

	public String getVipPrice() {
		return vipPrice;
	}

	public void setVipPrice(String vipPrice) {
		this.vipPrice = vipPrice;
	}

	public String getBrhPricePayid() {
		return brhPricePayid;
	}

	public void setBrhPricePayid(String brhPricePayid) {
		this.brhPricePayid = brhPricePayid;
	}

	public String getBrhPrice() {
		return brhPrice;
	}

	public void setBrhPrice(String brhPrice) {
		this.brhPrice = brhPrice;
	}

	public String getJfxjPricePayid() {
		return jfxjPricePayid;
	}

	public void setJfxjPricePayid(String jfxjPricePayid) {
		this.jfxjPricePayid = jfxjPricePayid;
	}

	public String getJfPart() {
		return jfPart;
	}

	public void setJfPart(String jfPart) {
		this.jfPart = jfPart;
	}

	public String getXjPart() {
		return xjPart;
	}

	public void setXjPart(String xjPart) {
		this.xjPart = xjPart;
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

	public String getPaywayIdY() {
		return paywayIdY;
	}

	public void setPaywayIdY(String paywayIdY) {
		this.paywayIdY = paywayIdY;
	}

	public String getStagesNum() {
		return stagesNum;
	}

	public void setStagesNum(String stagesNum) {
		this.stagesNum = stagesNum;
	}

	public String getPaywayIdF() {
		return paywayIdF;
	}

	public void setPaywayIdF(String paywayIdF) {
		this.paywayIdF = paywayIdF;
	}

	public String getDoDate() {
		return doDate;
	}

	public void setDoDate(String doDate) {
		this.doDate = doDate;
	}

	public String getDoTime() {
		return doTime;
	}

	public void setDoTime(String doTime) {
		this.doTime = doTime;
	}

	public String getFavoriteDesc() {
		return favoriteDesc;
	}

	public void setFavoriteDesc(String favoriteDesc) {
		this.favoriteDesc = favoriteDesc;
	}

	public String getPictureUrl() {
		return pictureUrl;
	}

	public void setPictureUrl(String pictureUrl) {
		this.pictureUrl = pictureUrl;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}
}
