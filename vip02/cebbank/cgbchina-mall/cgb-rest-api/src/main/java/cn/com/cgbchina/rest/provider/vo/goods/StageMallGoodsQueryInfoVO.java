package cn.com.cgbchina.rest.provider.vo.goods;

import java.io.Serializable;

import cn.com.cgbchina.rest.common.annotation.XMLNodeName;
import cn.com.cgbchina.rest.provider.vo.BaseEntityVO;
/**
 * MAL312	商品搜索列表(分期商城)
 * @author lizy
 *         2016/4/29.
 */
public class StageMallGoodsQueryInfoVO extends BaseEntityVO implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 9201110964330086119L;
	@XMLNodeName(value="goods_id")
	private String goodsId;
	@XMLNodeName(value="goods_nm")
	private String goodsNm;
	@XMLNodeName(value="goods_mid")
	private String goodsMid;
	@XMLNodeName(value="goods_oid")
	private String goodsOid;
	@XMLNodeName(value="goods_xid")
	private String goodsXid;
	@XMLNodeName(value="stages_num")
	private String stagesNum;
	@XMLNodeName(value="per_stage")
	private String perStage;
	@XMLNodeName(value="goods_price")
	private String goodsPrice;
	@XMLNodeName(value="goods_type")
	private String goodsType;
	@XMLNodeName(value="jp_price")
	private String jpPrice;
	@XMLNodeName(value="tz_price")
	private String tzPrice;
	@XMLNodeName(value="dz_price")
	private String dzPrice;
	@XMLNodeName(value="vip_price")
	private String vipPrice;
	@XMLNodeName(value="brh_price")
	private String brhPrice;
	@XMLNodeName(value="jf_part")
	private String jfPart;
	@XMLNodeName(value="xj_part")
	private String xjPart;
	@XMLNodeName(value="picture_url")
	private String pictureUrl;
	@XMLNodeName(value="market_price")
	private String marketPrice;
	@XMLNodeName(value="goods_total")
	private String goodsTotal;
	@XMLNodeName(value="goods_backlog")
	private String goodsBacklog;
	private String beginDate;
	private String beginTime;
	private String endDate;
	private String endTime;
	private String goodsActType;
	private String collectStatus;
	private Double bestRate;
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
	public String getPerStage() {
		return perStage;
	}
	public void setPerStage(String perStage) {
		this.perStage = perStage;
	}
	public String getGoodsPrice() {
		return goodsPrice;
	}
	public void setGoodsPrice(String goodsPrice) {
		this.goodsPrice = goodsPrice;
	}
	public String getGoodsType() {
		return goodsType;
	}
	public void setGoodsType(String goodsType) {
		this.goodsType = goodsType;
	}
	public String getJpPrice() {
		return jpPrice;
	}
	public void setJpPrice(String jpPrice) {
		this.jpPrice = jpPrice;
	}
	public String getTzPrice() {
		return tzPrice;
	}
	public void setTzPrice(String tzPrice) {
		this.tzPrice = tzPrice;
	}
	public String getDzPrice() {
		return dzPrice;
	}
	public void setDzPrice(String dzPrice) {
		this.dzPrice = dzPrice;
	}
	public String getVipPrice() {
		return vipPrice;
	}
	public void setVipPrice(String vipPrice) {
		this.vipPrice = vipPrice;
	}
	public String getBrhPrice() {
		return brhPrice;
	}
	public void setBrhPrice(String brhPrice) {
		this.brhPrice = brhPrice;
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
 
	public String getPictureUrl() {
		return pictureUrl;
	}
	public void setPictureUrl(String pictureUrl) {
		this.pictureUrl = pictureUrl;
	}
	public String getMarketPrice() {
		return marketPrice;
	}
	public void setMarketPrice(String marketPrice) {
		this.marketPrice = marketPrice;
	}
	public String getGoodsTotal() {
		return goodsTotal;
	}
	public void setGoodsTotal(String goodsTotal) {
		this.goodsTotal = goodsTotal;
	}
	public String getGoodsBacklog() {
		return goodsBacklog;
	}
	public void setGoodsBacklog(String goodsBacklog) {
		this.goodsBacklog = goodsBacklog;
	}
	public String getBeginDate() {
		return beginDate;
	}
	public void setBeginDate(String beginDate) {
		this.beginDate = beginDate;
	}
	public String getBeginTime() {
		return beginTime;
	}
	public void setBeginTime(String beginTime) {
		this.beginTime = beginTime;
	}
	public String getEndDate() {
		return endDate;
	}
	public void setEndDate(String endDate) {
		this.endDate = endDate;
	}
	public String getEndTime() {
		return endTime;
	}
	public void setEndTime(String endTime) {
		this.endTime = endTime;
	}
	public String getGoodsActType() {
		return goodsActType;
	}
	public void setGoodsActType(String goodsActType) {
		this.goodsActType = goodsActType;
	}
	public String getCollectStatus() {
		return collectStatus;
	}
	public void setCollectStatus(String collectStatus) {
		this.collectStatus = collectStatus;
	}
	public Double getBestRate() {
		return bestRate;
	}
	public void setBestRate(Double bestRate) {
		this.bestRate = bestRate;
	}
 
	
}
