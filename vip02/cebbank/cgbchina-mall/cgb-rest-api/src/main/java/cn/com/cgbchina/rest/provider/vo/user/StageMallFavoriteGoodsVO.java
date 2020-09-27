package cn.com.cgbchina.rest.provider.vo.user;

import java.io.Serializable;

import cn.com.cgbchina.rest.common.annotation.XMLNodeName;
import cn.com.cgbchina.rest.provider.vo.BaseEntityVO;

/**
 * MAL302 查询收藏商品(分期商城) 的商品信息
 * 
 * @author lizy 2016/4/28.
 */
public class StageMallFavoriteGoodsVO extends BaseEntityVO implements Serializable {
	private static final long serialVersionUID = -1117784758756142180L;
	@XMLNodeName(value = "cust_id")
	private String custId;
	private String id;
	@XMLNodeName(value = "goods_id")
	private String goodsId;
	@XMLNodeName(value = "goods_nm")
	private String goodsNm;
	@XMLNodeName(value = "ordertype_id")
	private String ordertypeId;
	@XMLNodeName(value = "goods_price_y")
	private String goodsPriceY;
	@XMLNodeName(value = "goods_price_f")
	private String goodsPriceF;
	@XMLNodeName(value = "goods_type")
	private String goodsType;
	@XMLNodeName(value = "jp_price_payid")
	private String jpPricePayid;
	@XMLNodeName(value = "jp_price")
	private String jpPrice;
	@XMLNodeName(value = "tz_price_payid")
	private String tzPricePayid;
	@XMLNodeName(value = "tz_price")
	private String tzPrice;
	@XMLNodeName(value = "dz_price_payid")
	private String dzPricePayid;
	@XMLNodeName(value = "dz_price")
	private String dzPrice;
	@XMLNodeName(value = "vip_price_payid")
	private String vipPricePayid;
	@XMLNodeName(value = "vip_price")
	private String vipPrice;
	@XMLNodeName(value = "brh_price_payid")
	private String brhPricePayid;
	@XMLNodeName(value = "brh_price")
	private String brhPrice;
	@XMLNodeName(value = "jfxj_price_payid")
	private String jfxjPricePayid;
	@XMLNodeName(value = "jf_part")
	private String jfPart;
	@XMLNodeName(value = "xj_part")
	private String xjPart;
	@XMLNodeName(value = "alert_num")
	private String alertNum;
	@XMLNodeName(value = "goods_backlog")
	private String goodsBacklog;
	@XMLNodeName(value = "payway_id_y")
	private String paywayIdY;
	@XMLNodeName(value = "stages_num")
	private String stagesNum;
	@XMLNodeName(value = "payway_id_f")
	private String paywayIdF;
	@XMLNodeName(value = "do_date")
	private String doDate;
	@XMLNodeName(value = "do_time")
	private String doTime;
	@XMLNodeName(value = "favorite_desc")
	private String favoriteDesc;
	@XMLNodeName(value = "picture_url")
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
