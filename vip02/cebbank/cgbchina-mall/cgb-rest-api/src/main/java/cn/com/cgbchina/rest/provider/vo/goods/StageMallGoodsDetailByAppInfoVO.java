package cn.com.cgbchina.rest.provider.vo.goods;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import cn.com.cgbchina.rest.provider.vo.BaseEntityVO;

/**
 * MAL313 商品详细信息(分期商城)
 * 
 * @author lizy 2016/5/3.
 */
public class StageMallGoodsDetailByAppInfoVO extends BaseEntityVO implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 8396705635910514833L;
	private String goodsNm;
	private String goodsMid;
	private String goodsOid;
	private String goodsXid;
	private String goodsPrice;
	private String areaCode;
	private String jfType;
	private String jfTypeNm;
	private String goods_type;
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
	private String actPointId;
	private String actPoint;
	private String vendorId;
	private String vendorFnm;
	private String vendorSnm;
	private String typePid;
	private String levelPnm;
	private String typeId;
	private String levelNm;
	private String goodsSize;
	private String alertNum;
	private String goodsBacklog;
	private String goodsDetailDesc;
	private String paywayIdY;
	private String pictureUrl;
	private String canIntegral;
	private String unitIntegral;
	private String goodsProp1;
	private String goodsProp2;
	private String marketPrice;
	private String countLimit;
	private String wechatStatus;
	private String wechatAStatus;
	private String vendorPhone;
	private String goodsType;
	private String actBeginDate;
	private String actBeginTime;
	private String actEndDate;
	private String actEndTime;
	private String mallDate;
	private String mallTime;
	private String actStatus;
	private String custLevel;
	private String custPointRate;
	private String ifFixPoint;
	private String vendorTime;
	private Double actionCount;
	private String soldNum;
	private String goodsTotal;
	private String remindStatus;
	private String collectStatus;
	private String bestRate;
	private String appStatus;
	private String actId;
	private List<StageMallGoodsDetailAttrInfoByAppVO> attrInfos = new ArrayList<StageMallGoodsDetailAttrInfoByAppVO>();
	private List<StageMallGoodsDetailStageInfoByAppVO> stageInfos = new ArrayList<StageMallGoodsDetailStageInfoByAppVO>();
	private List<StageMallGoodsDetailPrivilegeInfoByAppVO> privilegeInfos = new ArrayList<StageMallGoodsDetailPrivilegeInfoByAppVO>();

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

	public String getGoodsPrice() {
		return goodsPrice;
	}

	public void setGoodsPrice(String goodsPrice) {
		this.goodsPrice = goodsPrice;
	}

	public String getAreaCode() {
		return areaCode;
	}

	public void setAreaCode(String areaCode) {
		this.areaCode = areaCode;
	}

	public String getJfType() {
		return jfType;
	}

	public void setJfType(String jfType) {
		this.jfType = jfType;
	}

	public String getJfTypeNm() {
		return jfTypeNm;
	}

	public void setJfTypeNm(String jfTypeNm) {
		this.jfTypeNm = jfTypeNm;
	}

	public String getGoods_type() {
		return goods_type;
	}

	public void setGoods_type(String goods_type) {
		this.goods_type = goods_type;
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

	public String getActPointId() {
		return actPointId;
	}

	public void setActPointId(String actPointId) {
		this.actPointId = actPointId;
	}

	public String getActPoint() {
		return actPoint;
	}

	public void setActPoint(String actPoint) {
		this.actPoint = actPoint;
	}

	public String getVendorId() {
		return vendorId;
	}

	public void setVendorId(String vendorId) {
		this.vendorId = vendorId;
	}

	public String getVendorFnm() {
		return vendorFnm;
	}

	public void setVendorFnm(String vendorFnm) {
		this.vendorFnm = vendorFnm;
	}

	public String getVendorSnm() {
		return vendorSnm;
	}

	public void setVendorSnm(String vendorSnm) {
		this.vendorSnm = vendorSnm;
	}

	public String getTypePid() {
		return typePid;
	}

	public void setTypePid(String typePid) {
		this.typePid = typePid;
	}

	public String getLevelPnm() {
		return levelPnm;
	}

	public void setLevelPnm(String levelPnm) {
		this.levelPnm = levelPnm;
	}

	public String getTypeId() {
		return typeId;
	}

	public void setTypeId(String typeId) {
		this.typeId = typeId;
	}

	public String getLevelNm() {
		return levelNm;
	}

	public void setLevelNm(String levelNm) {
		this.levelNm = levelNm;
	}

	public String getGoodsSize() {
		return goodsSize;
	}

	public void setGoodsSize(String goodsSize) {
		this.goodsSize = goodsSize;
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

	public String getCanIntegral() {
		return canIntegral;
	}

	public void setCanIntegral(String canIntegral) {
		this.canIntegral = canIntegral;
	}

	public String getUnitIntegral() {
		return unitIntegral;
	}

	public void setUnitIntegral(String unitIntegral) {
		this.unitIntegral = unitIntegral;
	}

	public String getGoodsProp1() {
		return goodsProp1;
	}

	public void setGoodsProp1(String goodsProp1) {
		this.goodsProp1 = goodsProp1;
	}

	public String getGoodsProp2() {
		return goodsProp2;
	}

	public void setGoodsProp2(String goodsProp2) {
		this.goodsProp2 = goodsProp2;
	}

	public String getMarketPrice() {
		return marketPrice;
	}

	public void setMarketPrice(String marketPrice) {
		this.marketPrice = marketPrice;
	}

	public String getCountLimit() {
		return countLimit;
	}

	public void setCountLimit(String countLimit) {
		this.countLimit = countLimit;
	}

	public String getWechatStatus() {
		return wechatStatus;
	}

	public void setWechatStatus(String wechatStatus) {
		this.wechatStatus = wechatStatus;
	}

	public String getWechatAStatus() {
		return wechatAStatus;
	}

	public void setWechatAStatus(String wechatAStatus) {
		this.wechatAStatus = wechatAStatus;
	}

	public String getVendorPhone() {
		return vendorPhone;
	}

	public void setVendorPhone(String vendorPhone) {
		this.vendorPhone = vendorPhone;
	}

	public String getGoodsType() {
		return goodsType;
	}

	public void setGoodsType(String goodsType) {
		this.goodsType = goodsType;
	}

	public String getActBeginDate() {
		return actBeginDate;
	}

	public void setActBeginDate(String actBeginDate) {
		this.actBeginDate = actBeginDate;
	}

	public String getActBeginTime() {
		return actBeginTime;
	}

	public void setActBeginTime(String actBeginTime) {
		this.actBeginTime = actBeginTime;
	}

	public String getActEndDate() {
		return actEndDate;
	}

	public void setActEndDate(String actEndDate) {
		this.actEndDate = actEndDate;
	}

	public String getActEndTime() {
		return actEndTime;
	}

	public void setActEndTime(String actEndTime) {
		this.actEndTime = actEndTime;
	}

	public String getMallDate() {
		return mallDate;
	}

	public void setMallDate(String mallDate) {
		this.mallDate = mallDate;
	}

	public String getMallTime() {
		return mallTime;
	}

	public void setMallTime(String mallTime) {
		this.mallTime = mallTime;
	}

	public String getActStatus() {
		return actStatus;
	}

	public void setActStatus(String actStatus) {
		this.actStatus = actStatus;
	}

	public String getCustLevel() {
		return custLevel;
	}

	public void setCustLevel(String custLevel) {
		this.custLevel = custLevel;
	}

	public String getCustPointRate() {
		return custPointRate;
	}

	public void setCustPointRate(String custPointRate) {
		this.custPointRate = custPointRate;
	}

	public String getIfFixPoint() {
		return ifFixPoint;
	}

	public void setIfFixPoint(String ifFixPoint) {
		this.ifFixPoint = ifFixPoint;
	}

	public String getVendorTime() {
		return vendorTime;
	}

	public void setVendorTime(String vendorTime) {
		this.vendorTime = vendorTime;
	}

	public Double getActionCount() {
		return actionCount;
	}

	public void setActionCount(Double actionCount) {
		this.actionCount = actionCount;
	}

	public String getSoldNum() {
		return soldNum;
	}

	public void setSoldNum(String soldNum) {
		this.soldNum = soldNum;
	}

	public String getGoodsTotal() {
		return goodsTotal;
	}

	public void setGoodsTotal(String goodsTotal) {
		this.goodsTotal = goodsTotal;
	}

	public String getRemindStatus() {
		return remindStatus;
	}

	public void setRemindStatus(String remindStatus) {
		this.remindStatus = remindStatus;
	}

	public String getCollectStatus() {
		return collectStatus;
	}

	public void setCollectStatus(String collectStatus) {
		this.collectStatus = collectStatus;
	}

	public String getBestRate() {
		return bestRate;
	}

	public void setBestRate(String bestRate) {
		this.bestRate = bestRate;
	}

	public String getAppStatus() {
		return appStatus;
	}

	public void setAppStatus(String appStatus) {
		this.appStatus = appStatus;
	}

	public String getActId() {
		return actId;
	}

	public void setActId(String actId) {
		this.actId = actId;
	}

	public List<StageMallGoodsDetailAttrInfoByAppVO> getAttrInfos() {
		return attrInfos;
	}

	public void setAttrInfos(List<StageMallGoodsDetailAttrInfoByAppVO> attrInfos) {
		this.attrInfos = attrInfos;
	}

	public List<StageMallGoodsDetailStageInfoByAppVO> getStageInfos() {
		return stageInfos;
	}

	public void setStageInfos(List<StageMallGoodsDetailStageInfoByAppVO> stageInfos) {
		this.stageInfos = stageInfos;
	}

	public List<StageMallGoodsDetailPrivilegeInfoByAppVO> getPrivilegeInfos() {
		return privilegeInfos;
	}

	public void setPrivilegeInfos(List<StageMallGoodsDetailPrivilegeInfoByAppVO> privilegeInfos) {
		this.privilegeInfos = privilegeInfos;
	}

}
