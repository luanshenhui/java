package cn.rkylin.oms.item.domain;

import cn.rkylin.oms.common.base.BaseEntity;
import com.fasterxml.jackson.annotation.JsonFormat;

import java.math.BigDecimal;
import java.util.Date;

/**
 * 平台商品实体，对应oms_ec_item表
 *
 * @author wangxing
 * @version 1.0
 * @created 14-2月-2017 16:00:00
 */
public class Item extends BaseEntity {
	/**
	 * 序列化id
	 */
	private static final long serialVersionUID = 2311442258392774878L;

	private String ecItemId;

	private String ecItemCode;

	private String ecItemName;

	private String outerCode;

	private String prjId;

	private String prjName;

	private String shopId;

	private String shopName;

	private String shopAccount;

	private String shopType;

	private String itemUrl;

	private BigDecimal salePrice;

	private BigDecimal postFee;

	private BigDecimal emsPostFee;

	private BigDecimal lgstPostFee;

	private String remark;

	private String approveStatus;
	
	private String qty;
	
	public String getQty() {
		return qty;
	}

	public void setQty(String qty) {
		this.qty = qty;
	}

	/**
	 * 上架时间
	 */
	@JsonFormat(pattern="yyyy-MM-dd HH:mm:ss",timezone = "GMT+8")
	private Date listTime;

	private String autoList;

	/**
	 * 下架时间
	 */
	@JsonFormat(pattern="yyyy-MM-dd HH:mm:ss",timezone = "GMT+8")
	private Date delistTime;

	private String autoDelist;

	/**
	 * 创建时间
	 */
	@JsonFormat(pattern="yyyy-MM-dd HH:mm:ss",timezone = "GMT+8")
	private Date createTime;

	/**
	 * 修改时间
	 */
	@JsonFormat(pattern="yyyy-MM-dd HH:mm:ss",timezone = "GMT+8")
	private Date updateTime;

	private String deleted;

	public String getEcItemId() {
		return ecItemId;
	}

	public void setEcItemId(String ecItemId) {
		this.ecItemId = ecItemId == null ? null : ecItemId.trim();
	}

	public String getEcItemCode() {
		return ecItemCode;
	}

	public void setEcItemCode(String ecItemCode) {
		this.ecItemCode = ecItemCode == null ? null : ecItemCode.trim();
	}

	public String getEcItemName() {
		return ecItemName;
	}

	public void setEcItemName(String ecItemName) {
		this.ecItemName = ecItemName == null ? null : ecItemName.trim();
	}

	public String getOuterCode() {
		return outerCode;
	}

	public void setOuterCode(String outerCode) {
		this.outerCode = outerCode == null ? null : outerCode.trim();
	}

	public String getPrjId() {
		return prjId;
	}

	public void setPrjId(String prjId) {
		this.prjId = prjId == null ? null : prjId.trim();
	}

	public String getPrjName() {
		return prjName;
	}

	public void setPrjName(String prjName) {
		this.prjName = prjName == null ? null : prjName.trim();
	}

	public String getShopId() {
		return shopId;
	}

	public void setShopId(String shopId) {
		this.shopId = shopId == null ? null : shopId.trim();
	}

	public String getShopName() {
		return shopName;
	}

	public void setShopName(String shopName) {
		this.shopName = shopName == null ? null : shopName.trim();
	}

	public String getShopAccount() {
		return shopAccount;
	}

	public void setShopAccount(String shopAccount) {
		this.shopAccount = shopAccount == null ? null : shopAccount.trim();
	}

	public String getShopType() {
		return shopType;
	}

	public void setShopType(String shopType) {
		this.shopType = shopType == null ? null : shopType.trim();
	}

	public String getItemUrl() {
		return itemUrl;
	}

	public void setItemUrl(String itemUrl) {
		this.itemUrl = itemUrl == null ? null : itemUrl.trim();
	}

	public BigDecimal getSalePrice() {
		return salePrice;
	}

	public void setSalePrice(BigDecimal salePrice) {
		this.salePrice = salePrice;
	}

	public BigDecimal getPostFee() {
		return postFee;
	}

	public void setPostFee(BigDecimal postFee) {
		this.postFee = postFee;
	}

	public BigDecimal getEmsPostFee() {
		return emsPostFee;
	}

	public void setEmsPostFee(BigDecimal emsPostFee) {
		this.emsPostFee = emsPostFee;
	}

	public BigDecimal getLgstPostFee() {
		return lgstPostFee;
	}

	public void setLgstPostFee(BigDecimal lgstPostFee) {
		this.lgstPostFee = lgstPostFee;
	}

	public String getRemark() {
		return remark;
	}

	public void setRemark(String remark) {
		this.remark = remark == null ? null : remark.trim();
	}

	public String getApproveStatus() {
		return approveStatus;
	}

	public void setApproveStatus(String approveStatus) {
		this.approveStatus = approveStatus == null ? null : approveStatus.trim();
	}

	public Date getListTime() {
		return listTime;
	}

	public void setListTime(Date listTime) {
		this.listTime = listTime;
	}

	public String getAutoList() {
		return autoList;
	}

	public void setAutoList(String autoList) {
		this.autoList = autoList == null ? null : autoList.trim();
	}

	public Date getDelistTime() {
		return delistTime;
	}

	public void setDelistTime(Date delistTime) {
		this.delistTime = delistTime;
	}

	public String getAutoDelist() {
		return autoDelist;
	}

	public void setAutoDelist(String autoDelist) {
		this.autoDelist = autoDelist == null ? null : autoDelist.trim();
	}

	public Date getCreateTime() {
		return createTime;
	}

	public void setCreateTime(Date createTime) {
		this.createTime = createTime;
	}

	public Date getUpdateTime() {
		return updateTime;
	}

	public void setUpdateTime(Date updateTime) {
		this.updateTime = updateTime;
	}

	public String getDeleted() {
		return deleted;
	}

	public void setDeleted(String deleted) {
		this.deleted = deleted == null ? null : deleted.trim();
	}
}