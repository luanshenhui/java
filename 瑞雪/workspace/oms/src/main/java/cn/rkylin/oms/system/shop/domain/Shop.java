package cn.rkylin.oms.system.shop.domain;

import java.util.Date;

import com.alibaba.fastjson.annotation.JSONField;
import com.fasterxml.jackson.annotation.JsonFormat;

import cn.rkylin.oms.common.base.BaseEntity;

/**
 * 店铺实体，对应shop表
 * 
 * @author wangxiaoyi
 * @version 1.0
 * @created 13-1月-2017 09:11:15
 */
public class Shop extends BaseEntity {
	/**
	 * 序列化id
	 */
	private static final long serialVersionUID = 2311449459392774878L;

	/**
	 * 店铺id
	 */
	private String shopId;

	/**
	 * 店铺名称
	 */
	private String shopName;

	/**
	 * 项目id
	 */
	private String prjId;
	/**
	 * 项目
	 */
	private String prjName;

	public String getPrjName() {
		return prjName;
	}

	public void setPrjName(String prjName) {
		this.prjName = prjName;
	}

	/**
	 * 店铺类型
	 */
	private String shopType;

	/**
	 * 店铺帐号
	 */
	private String shopAccount;

	/**
	 * 验证？
	 */
	private String validate;

	/**
	 * 可用？
	 */
	private String enable;

	/**
	 * 删除？
	 */
	private String deleted;

	/**
	 * 是否需要拆单
	 */
	private String needSplitOrder;

	/**
	 * 父店铺
	 */
	private String parentShop;
	
	/**
	 * 开始时间
	 */
	@JsonFormat(pattern="yyyy-MM-dd HH:mm:ss",timezone = "GMT+8")
	private Date startTime;

	/**
	 * 过期时间
	 */
	@JsonFormat(pattern="yyyy-MM-dd HH:mm:ss",timezone = "GMT+8")
	private Date expireTime;

	/**
	 * 创建时间
	 */
	@JsonFormat(pattern="yyyy-MM-dd HH:mm:ss",timezone = "GMT+8")
	private Date createTime;

	/**
	 * 修改时间
	 */
	@JsonFormat(pattern="yyyy-MM-dd HH:mm:ss",timezone = "GMT+8")
	private Date modifyTime;

	/**
	 * 备注
	 */
	private String remark;

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

	public String getPrjId() {
		return prjId;
	}

	public void setPrjId(String prjId) {
		this.prjId = prjId == null ? null : prjId.trim();
	}

	public String getShopType() {
		return shopType;
	}

	public void setShopType(String shopType) {
		this.shopType = shopType == null ? null : shopType.trim();
	}

	public String getShopAccount() {
		return shopAccount;
	}

	public void setShopAccount(String shopAccount) {
		this.shopAccount = shopAccount == null ? null : shopAccount.trim();
	}

	public String getValidate() {
		return validate;
	}

	public void setValidate(String validate) {
		this.validate = validate == null ? null : validate.trim();
	}

	public String getEnable() {
		return enable;
	}

	public void setEnable(String enable) {
		this.enable = enable == null ? null : enable.trim();
	}

	public String getDeleted() {
		return deleted;
	}

	public String getNeedSplitOrder() {
		return needSplitOrder;
	}

	public void setNeedSplitOrder(String needSplitOrder) {
		this.needSplitOrder = needSplitOrder;
	}

	public String getParentShop() {
		return parentShop;
	}

	public void setParentShop(String parentShop) {
		this.parentShop = parentShop;
	}

	public void setDeleted(String deleted) {
		this.deleted = deleted == null ? null : deleted.trim();
	}

	public Date getExpireTime() {
		return expireTime;
	}

	public void setExpireTime(Date expireTime) {
		this.expireTime = expireTime;
	}

	public Date getCreateTime() {
		return createTime;
	}

	public void setCreateTime(Date createTime) {
		this.createTime = createTime;
	}

	public Date getModifyTime() {
		return modifyTime;
	}

	public void setModifyTime(Date modifyTime) {
		this.modifyTime = modifyTime;
	}

	public Date getStartTime() {
		return startTime;
	}

	public void setStartTime(Date startTime) {
		this.startTime = startTime;
	}

	public String getRemark() {
		return remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}
	
	private String apiUrl;
	private String appKey;
	private String appSecret;
	private String sessionKey;

	public String getApiUrl() {
		return apiUrl;
	}

	public void setApiUrl(String apiUrl) {
		this.apiUrl = apiUrl;
	}

	public String getAppKey() {
		return appKey;
	}

	public void setAppKey(String appKey) {
		this.appKey = appKey;
	}

	public String getAppSecret() {
		return appSecret;
	}

	public void setAppSecret(String appSecret) {
		this.appSecret = appSecret;
	}

	public String getSessionKey() {
		return sessionKey;
	}

	public void setSessionKey(String sessionKey) {
		this.sessionKey = sessionKey;
	}
	
	
}