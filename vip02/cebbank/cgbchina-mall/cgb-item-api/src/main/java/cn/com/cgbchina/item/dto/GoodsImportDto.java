/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.item.dto;

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

    private static final long serialVersionUID = 7562998090179593723L;
    @Getter
    @Setter
    private String successFlag;//导入成功标志
    @Getter
    @Setter
    private String failReason;//失败原因
    @Getter
    @Setter
    private String goodsCode;//商品编码
    @Getter
    @Setter
    private String itemCode;//单品编码
    @Getter
    @Setter
    private String goodsFlag;//商品标志
    @Getter
    @Setter
    private String goodsName;//商品名称
    @Getter
    @Setter
    private String ordertypeId;//业务类型
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
    private String mailOrderCode;// 邮购分期类别码
    @Getter
    @Setter
    private String promotionTitle;// 营销语
    @Getter
    @Setter
    private String adWord;// 商品卖点
    @Getter
    @Setter
    private String giftDesc;// 赠品信息
    @Getter
    @Setter
    private String introduction;// 商品描述
    @Getter
    @Setter
    private String serviceType;// 服务承诺 多个值逗号分割
    @Getter
    @Setter
    private String recommendGoods1Code;// 关联推荐商品1
    @Getter
    @Setter
    private String recommendGoods2Code;// 关联推荐商品2
    @Getter
    @Setter
    private String recommendGoods3Code;// 关联推荐商品3
    @Getter
    @Setter
    private String cards;// 第三级卡产品编码，逗号分割
    @Getter
    @Setter
    private String marketPrice;// 市场价格
    @Getter
    @Setter
    private String price;// 实际价格
    @Getter
    @Setter
    private String stock;// 实际库存
    @Getter
    @Setter
    private String stockWarning;// 库存预警
    @Getter
    @Setter
    private String o2oCode;// o2o商品编码
    @Getter
    @Setter
    private String o2oVoucherCode;// o2o兑换券编码
    @Getter
    @Setter
    private String fixPoint;// 固定积分
    @Getter
    @Setter
    private java.math.BigDecimal cash;//现金
    @Getter
    @Setter
    private String installmentNumber;//最高期数
    @Getter
    @Setter
    private String attribute1Name;//属性1
    @Getter
    @Setter
    private String attribute1ValueName;//属性值1
    @Getter
    @Setter
    private String attribute2Name;//属性2
    @Getter
    @Setter
    private String attribute2ValueName;//属性值2
    @Getter
    @Setter
    private String attribute3Name;//属性3
    @Getter
    @Setter
    private String attribute3ValueName;//属性值3
    @Getter
    @Setter
    private String attribute4Name;//属性4
    @Getter
    @Setter
    private String attribute4ValueName;//属性值4
    @Getter
    @Setter
    private String attribute5Name;//属性5
    @Getter
    @Setter
    private String attribute5ValueName;//属性值5
    @Getter
    @Setter
    private String attribute6Name;//属性6
    @Getter
    @Setter
    private String attribute6ValueName;//属性值6
    @Getter
    @Setter
    private String attribute7Name;//属性7
    @Getter
    @Setter
    private String attribute7ValueName;//属性值7
    @Getter
    @Setter
    private String attribute8Name;//属性8
    @Getter
    @Setter
    private String attribute8ValueName;//属性值8


    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        GoodsImportDto that = (GoodsImportDto) o;

        return Objects.equal(this.goodsCode, that.goodsCode) &&
                Objects.equal(this.itemCode, that.itemCode) &&
                Objects.equal(this.goodsFlag, that.goodsFlag) &&
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
                Objects.equal(this.mailOrderCode, that.mailOrderCode) &&
                Objects.equal(this.promotionTitle, that.promotionTitle) &&
                Objects.equal(this.adWord, that.adWord) &&
                Objects.equal(this.giftDesc, that.giftDesc) &&
                Objects.equal(this.introduction, that.introduction) &&
                Objects.equal(this.serviceType, that.serviceType) &&
                Objects.equal(this.recommendGoods1Code, that.recommendGoods1Code) &&
                Objects.equal(this.recommendGoods2Code, that.recommendGoods2Code) &&
                Objects.equal(this.recommendGoods3Code, that.recommendGoods3Code) &&
                Objects.equal(this.cards, that.cards) &&
                Objects.equal(this.marketPrice, that.marketPrice) &&
                Objects.equal(this.price, that.price) &&
                Objects.equal(this.stock, that.stock) &&
                Objects.equal(this.stockWarning, that.stockWarning) &&
                Objects.equal(this.o2oCode, that.o2oCode) &&
                Objects.equal(this.o2oVoucherCode, that.o2oVoucherCode) &&
                Objects.equal(this.fixPoint, that.fixPoint) &&
                Objects.equal(this.attribute1Name, that.attribute1Name) &&
                Objects.equal(this.attribute1ValueName, that.attribute1ValueName) &&
                Objects.equal(this.attribute2Name, that.attribute2Name) &&
                Objects.equal(this.attribute2ValueName, that.attribute2ValueName) &&
                Objects.equal(this.attribute3Name, that.attribute3Name) &&
                Objects.equal(this.attribute3ValueName, that.attribute3ValueName) &&
                Objects.equal(this.attribute4Name, that.attribute4Name) &&
                Objects.equal(this.attribute4ValueName, that.attribute4ValueName) &&
                Objects.equal(this.attribute5Name, that.attribute5Name) &&
                Objects.equal(this.attribute5ValueName, that.attribute5ValueName) &&
                Objects.equal(this.attribute6Name, that.attribute6Name) &&
                Objects.equal(this.attribute6ValueName, that.attribute6ValueName) &&
                Objects.equal(this.attribute7Name, that.attribute7Name) &&
                Objects.equal(this.attribute7ValueName, that.attribute7ValueName) &&
                Objects.equal(this.attribute8Name, that.attribute8Name) &&
                Objects.equal(this.attribute8ValueName, that.attribute8ValueName);
    }

    @Override
    public int hashCode() {
        return Objects.hashCode(goodsCode, itemCode, goodsFlag, goodsName, productName, manufacturer,
                vendorId, brandName, backCategory1Id, backCategory2Id, backCategory3Id,
                goodsType, isInner, mailOrderCode, promotionTitle,
                adWord, giftDesc, introduction, serviceType, recommendGoods1Code,
                recommendGoods2Code, recommendGoods3Code, cards, marketPrice, price,
                stock, stockWarning, o2oCode, o2oVoucherCode, fixPoint,
                attribute1Name, attribute1ValueName, attribute2Name, attribute2ValueName, attribute3Name,
                attribute3ValueName, attribute4Name, attribute4ValueName, attribute5Name, attribute5ValueName,
                attribute6Name, attribute6ValueName, attribute7Name, attribute7ValueName, attribute8Name,
                attribute8ValueName);
    }

    @Override
    public String toString() {
        return Objects.toStringHelper(this)
                .add("goodsCode", goodsCode)
                .add("itemCode", itemCode)
                .add("goodsFlag", goodsFlag)
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
                .add("mailOrderCode", mailOrderCode)
                .add("promotionTitle", promotionTitle)
                .add("adWord", adWord)
                .add("giftDesc", giftDesc)
                .add("introduction", introduction)
                .add("serviceType", serviceType)
                .add("recommendGoods1Code", recommendGoods1Code)
                .add("recommendGoods2Code", recommendGoods2Code)
                .add("recommendGoods3Code", recommendGoods3Code)
                .add("cards", cards)
                .add("marketPrice", marketPrice)
                .add("price", price)
                .add("stock", stock)
                .add("stockWarning", stockWarning)
                .add("o2oCode", o2oCode)
                .add("o2oVoucherCode", o2oVoucherCode)
                .add("fixPoint", fixPoint)
                .add("attribute1Name", attribute1Name)
                .add("attribute1ValueName", attribute1ValueName)
                .add("attribute2Name", attribute2Name)
                .add("attribute2ValueName", attribute2ValueName)
                .add("attribute3Name", attribute3Name)
                .add("attribute3ValueName", attribute3ValueName)
                .add("attribute4Name", attribute4Name)
                .add("attribute4ValueName", attribute4ValueName)
                .add("attribute5Name", attribute5Name)
                .add("attribute5ValueName", attribute5ValueName)
                .add("attribute6Name", attribute6Name)
                .add("attribute6ValueName", attribute6ValueName)
                .add("attribute7Name", attribute7Name)
                .add("attribute7ValueName", attribute7ValueName)
                .add("attribute8Name", attribute8Name)
                .add("attribute8ValueName", attribute8ValueName)
                .toString();
    }
}

