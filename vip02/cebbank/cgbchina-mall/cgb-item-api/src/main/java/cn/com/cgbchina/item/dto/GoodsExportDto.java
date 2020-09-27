/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.item.dto;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

/**
 * @author 陈乐
 * @version 1.0
 * @Since 2016/6/30.
 */


public class GoodsExportDto implements Serializable{

    private static final long serialVersionUID = 5161353011947182720L;
    @Getter
    @Setter
    private String goodsCode;//商品编码
    @Getter
    @Setter
    private String itemCode;//单品编码
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
    private String vendorName;//供应商名称
    @Getter
    @Setter
    private String brandName;//品牌信息
    @Getter
    @Setter
    private String backCategory1Name;// 一级后台类目
    @Getter
    @Setter
    private String backCategory2Name;// 二级后台类目
    @Getter
    @Setter
    private String backCategory3Name;// 三级后台类目
    @Getter
    @Setter
    private String goodsType;// 商品类型
    @Getter
    @Setter
    private String isInner;// 是否内宣商品0是1否
    @Getter
    @Setter
    private Integer installmentNumber;// 最高期数
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

}

