package cn.rkylin.oms.system.splitRule.domain;

import java.util.Date;

import cn.rkylin.oms.common.base.BaseEntity;

public class SplitRule extends BaseEntity {
	/**
	 * 
	 */
	private static final long serialVersionUID = -7483874863964889826L;

    private String splitRuleId;

    private String shopId;

    private String shopName;

    private String shopType;

    private String splitType;

    private Date createTime;

    private Date updateTime;

    private String deleted;

    private String enable;
    
    public String getSplitRuleId() {
        return splitRuleId;
    }

    public void setSplitRuleId(String splitRuleId) {
        this.splitRuleId = splitRuleId == null ? null : splitRuleId.trim();
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

    public String getShopType() {
        return shopType;
    }

    public void setShopType(String shopType) {
        this.shopType = shopType == null ? null : shopType.trim();
    }

    public String getSplitType() {
        return splitType;
    }

    public void setSplitType(String splitType) {
        this.splitType = splitType == null ? null : splitType.trim();
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
    
    public String getEnable() {
        return enable;
    }

    public void setEnable(String enable) {
        this.enable = enable == null ? null : enable.trim();
    }
}