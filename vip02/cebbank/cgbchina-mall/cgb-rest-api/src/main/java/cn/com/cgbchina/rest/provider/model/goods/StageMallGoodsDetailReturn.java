package cn.com.cgbchina.rest.provider.model.goods;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import cn.com.cgbchina.rest.provider.model.BaseEntity;

/**
 * MAL117 商品详细信息(分期商城)
 * 
 * @author lizy 2016/4/28.
 */
public class StageMallGoodsDetailReturn extends BaseEntity implements Serializable {

	private static final long serialVersionUID = 332005257978863183L;

	private String goodsId;
	private String goodsNm;
	private String goodsMid;
	private String goodsOid;
	private String goodsXid;
	private String goodsPrice;
	private String vendorId;
	private String vendorFnm;
	private String vendorSnm;
	private String typePid;
	private String levelPnm;
	private String typeId;
	private String levelNm;
	private String goodsColor;
	private String goodsSize;
	private String goodsBacklog;
	private String goodsBaseDesc;
	private String goodsDetailDesc;
	private String phone;
	private String paywayIdY;
	private String goodsPresent;
	private String actionType;
	private String canIntegral;
	private String unitIntegral;
	private String loopCount;
	private List<StageMallGoodsDetailStageInfo> stageMallGoodsDetailStageInfos = new ArrayList<StageMallGoodsDetailStageInfo>();
	private List<StageMallGoodsDetailPrivilegeInfo> stageMallGoodsDetailPrivilegeInfos = new ArrayList<StageMallGoodsDetailPrivilegeInfo>();

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

	public String getGoodsPrice() {
		return goodsPrice;
	}

	public void setGoodsPrice(String goodsPrice) {
		this.goodsPrice = goodsPrice;
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

	public String getGoodsBaseDesc() {
		return goodsBaseDesc;
	}

	public void setGoodsBaseDesc(String goodsBaseDesc) {
		this.goodsBaseDesc = goodsBaseDesc;
	}

	public String getGoodsDetailDesc() {
		return goodsDetailDesc;
	}

	public void setGoodsDetailDesc(String goodsDetailDesc) {
		this.goodsDetailDesc = goodsDetailDesc;
	}

	public String getPhone() {
		return phone;
	}

	public void setPhone(String phone) {
		this.phone = phone;
	}

	public String getPaywayIdY() {
		return paywayIdY;
	}

	public void setPaywayIdY(String paywayIdY) {
		this.paywayIdY = paywayIdY;
	}

	public String getGoodsPresent() {
		return goodsPresent;
	}

	public void setGoodsPresent(String goodsPresent) {
		this.goodsPresent = goodsPresent;
	}

	public String getActionType() {
		return actionType;
	}

	public void setActionType(String actionType) {
		this.actionType = actionType;
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

	public String getLoopCount() {
		return loopCount;
	}

	public void setLoopCount(String loopCount) {
		this.loopCount = loopCount;
	}

	public List<StageMallGoodsDetailStageInfo> getStageMallGoodsDetailStageInfos() {
		return stageMallGoodsDetailStageInfos;
	}

	public void setStageMallGoodsDetailStageInfos(List<StageMallGoodsDetailStageInfo> stageMallGoodsDetailStageInfos) {
		this.stageMallGoodsDetailStageInfos = stageMallGoodsDetailStageInfos;
	}

	public List<StageMallGoodsDetailPrivilegeInfo> getStageMallGoodsDetailPrivilegeInfos() {
		return stageMallGoodsDetailPrivilegeInfos;
	}

	public void setStageMallGoodsDetailPrivilegeInfos(
			List<StageMallGoodsDetailPrivilegeInfo> stageMallGoodsDetailPrivilegeInfos) {
		this.stageMallGoodsDetailPrivilegeInfos = stageMallGoodsDetailPrivilegeInfos;
	}
}
