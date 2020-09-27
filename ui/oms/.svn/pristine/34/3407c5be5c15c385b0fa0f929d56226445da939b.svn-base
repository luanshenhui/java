package cn.rkylin.oms.item.domain;

import cn.rkylin.oms.common.base.BaseEntity;
import com.fasterxml.jackson.annotation.JsonFormat;

import java.math.BigDecimal;
import java.util.Date;

/**
 * 平台规格实体，对应oms_ec_sku表
 *
 * @author wangxing
 * @version 1.0
 * @created 15-2月-2017 10:00:00
 */
public class Sku extends BaseEntity {
    /**
     * 序列化id
     */
    private static final long serialVersionUID = 2399942258392774878L;

    private String ecSkuId;

    private String ecItemId;

    private String ecSkuCode;

    private String ecSkuName;

    private String outerCode;

    private BigDecimal salePrice;

    private BigDecimal weight;

    private Integer qty;

    private BigDecimal postFee;

    private String autoStock;

    /**
     * 创建时间
     */
    @JsonFormat(pattern="yyyy-MM-dd HH:mm:ss",timezone = "GMT+8")
    private Date createTime;
    /**
     * 更新时间
     */
    @JsonFormat(pattern="yyyy-MM-dd HH:mm:ss",timezone = "GMT+8")
    private Date updateTime;

    private String deleted;

    public String getEcSkuId() {
        return ecSkuId;
    }

    public void setEcSkuId(String ecSkuId) {
        this.ecSkuId = ecSkuId == null ? null : ecSkuId.trim();
    }

    public String getEcItemId() {
        return ecItemId;
    }

    public void setEcItemId(String ecItemId) {
        this.ecItemId = ecItemId == null ? null : ecItemId.trim();
    }

    public String getEcSkuCode() {
        return ecSkuCode;
    }

    public void setEcSkuCode(String ecSkuCode) {
        this.ecSkuCode = ecSkuCode == null ? null : ecSkuCode.trim();
    }

    public String getEcSkuName() {
        return ecSkuName;
    }

    public void setEcSkuName(String ecSkuName) {
        this.ecSkuName = ecSkuName == null ? null : ecSkuName.trim();
    }

    public String getOuterCode() {
        return outerCode;
    }

    public void setOuterCode(String outerCode) {
        this.outerCode = outerCode == null ? null : outerCode.trim();
    }

    public BigDecimal getSalePrice() {
        return salePrice;
    }

    public void setSalePrice(BigDecimal salePrice) {
        this.salePrice = salePrice;
    }

    public BigDecimal getWeight() {
        return weight;
    }

    public void setWeight(BigDecimal weight) {
        this.weight = weight;
    }

    public Integer getQty() {
        return qty;
    }

    public void setQty(Integer qty) {
        this.qty = qty;
    }

    public BigDecimal getPostFee() {
        return postFee;
    }

    public void setPostFee(BigDecimal postFee) {
        this.postFee = postFee;
    }

    public String getAutoStock() {
        return autoStock;
    }

    public void setAutoStock(String autoStock) {
        this.autoStock = autoStock == null ? null : autoStock.trim();
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