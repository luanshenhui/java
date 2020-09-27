/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.item.dto;

import com.google.common.base.MoreObjects;
import com.google.common.base.Objects;
import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

/**
 * @author 陈乐
 * @version 1.0
 * @Since 2016/6/23.
 */

public class GoodsImportDto implements Serializable{

    private static final long serialVersionUID = 1978193100861332096L;
    @Getter
    @Setter
    private String successFlag;//成功标志
    @Getter
    @Setter
    private String failReason;//错误信息
    @Getter
    @Setter
    private String goodsCode;//商品编码
    @Getter
    @Setter
    private String goodsName;//商品名称
    @Getter
    @Setter
    private String productName;//产品名称
    @Getter
    @Setter
    private String manufacturer;//生产厂家
    @Getter
    @Setter
    private String vendorId;//供应商编码
    @Getter
    @Setter
    private String brandName;//品牌信息
    @Getter
    @Setter
    private String backCategory1Id;// 一级后台类目
    @Getter
    @Setter
    private String backCategory2Id;// 二级后台类目
    @Getter
    @Setter
    private String backCategory3Id;// 三级后台类目
    @Getter
    @Setter
    private String goodsType;// 商品类型
    @Getter
    @Setter
    private String isInner;// 是否内宣商品0是1否
    @Getter
    @Setter
    private String cards;// 第三级卡产品编码，逗号分割
    @Getter
    @Setter
    private String ordertypeId;//业务类型
    @Getter
    @Setter
    private String createType;//创建类型
    @Getter
    @Setter
    private String mailOrderCode;//邮购分期类别码

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        GoodsImportDto that = (GoodsImportDto) o;

        return Objects.equal(this.successFlag, that.successFlag) &&
                Objects.equal(this.failReason, that.failReason) &&
                Objects.equal(this.goodsCode, that.goodsCode) &&
                Objects.equal(this.goodsName, that.goodsName) &&
                Objects.equal(this.productName, that.productName) &&
                Objects.equal(this.manufacturer, that.manufacturer) &&
                Objects.equal(this.vendorId, that.vendorId) &&
                Objects.equal(this.brandName, that.brandName) &&
                Objects.equal(this.backCategory1Id, that.backCategory1Id) &&
                Objects.equal(this.backCategory2Id, that.backCategory2Id) &&
                Objects.equal(this.backCategory3Id, that.backCategory3Id) &&
                Objects.equal(this.goodsType, that.goodsType) &&
                Objects.equal(this.isInner, that.isInner) &&
                Objects.equal(this.cards, that.cards) &&
                Objects.equal(this.ordertypeId, that.ordertypeId) &&
                Objects.equal(this.createType, that.createType) &&
                Objects.equal(this.mailOrderCode, that.mailOrderCode);
    }

    @Override
    public int hashCode() {
        return Objects.hashCode(successFlag, failReason, goodsCode, goodsName, productName, manufacturer,
                vendorId, brandName, backCategory1Id, backCategory2Id, backCategory3Id,
                goodsType, isInner, cards, ordertypeId, createType,
                mailOrderCode);
    }

    @Override
    public String toString() {
        return MoreObjects.toStringHelper(this)
                .add("successFlag", successFlag)
                .add("failReason", failReason)
                .add("goodsCode", goodsCode)
                .add("goodsName", goodsName)
                .add("productName", productName)
                .add("manufacturer", manufacturer)
                .add("vendorId", vendorId)
                .add("brandName", brandName)
                .add("backCategory1Id", backCategory1Id)
                .add("backCategory2Id", backCategory2Id)
                .add("backCategory3Id", backCategory3Id)
                .add("goodsType", goodsType)
                .add("isInner", isInner)
                .add("cards", cards)
                .add("ordertypeId", ordertypeId)
                .add("createType", createType)
                .add("mailOrderCode", mailOrderCode)
                .toString();
    }
}

