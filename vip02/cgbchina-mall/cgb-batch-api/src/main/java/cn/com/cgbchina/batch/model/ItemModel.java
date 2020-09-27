package cn.com.cgbchina.batch.model;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.io.Serializable;
import java.math.BigDecimal;

@Getter
@Setter
@ToString
public class ItemModel extends BaseModel implements Serializable {
    private static final long serialVersionUID = 7564716368415068050L;
    private String code;// 单品编码
    private String goodsCode;// 商品code
    private BigDecimal marketPrice;// 市场价格
    private BigDecimal price;// 实际价格
    private Long stock;// 实际库存
    private String o2oCode;// o2o商品编码
    private String o2oVoucherCode;// o2o兑换券编码
    private String installmentNumber;// 最高期数
//    private BigDecimal cash;// 现金 TODO 该字段已经删除
    private Long stockWarning;// 库存预警
    private java.util.Date nostockNotifyTime;// 库存预警消息发送时间
    private String image1;// 图片1
    private String image2;// 图片2
    private String image3;// 图片3
    private String image4;// 图片4
    private String image5;// 图片5
    private String freightSize;// 商品体积
    private String freightWeight;// 商品重量
    private String stagesCode;// 一期邮购分期类别码
    private Long fixPoint;// 固定积分
    private String machCode;// 条形码
    private Long goodsTotal;//
    private Integer stickFlag;// 置顶标志（默认0 非置顶，1置顶）
    private Integer stickOrder;// 置顶商品显示顺序
    private Long wxOrder;// 微信商品显示顺序
    private String delFlag;// 逻辑删除标记 0：未删除 1：已删除
    private String createOper;// 创建者
    private java.util.Date createTime;// 创建时间
    private String modifyOper;// 修改者
    private java.util.Date modifyTime;// 修改时间
//    private String attribute;// 单品属性list
    private String mid;// 商品ID(分期唯一值用于外系统)
    private String oid;// 商品ID(一次性唯一值用于外系统)
    private String xid;// 礼品编码
    private String bid;// 虚拟礼品代号
    private String wxProp1;// 商品属性一（微信商品用，商品详情）
    private String wxProp2;// 商品属性二（微信商品用，商品参数）
    private String wxProp3;// 商品属性三
    private Integer preinstallStock;// 预设库存
    private BigDecimal productPointRate;// 商品积分
    private BigDecimal bestRate;// 最佳倍率
    private Long maxPoint;// 最大积分
    private String cardLevelId;// 卡等级编码
    private String prefuctureId; // 专区ID
    private Integer virtualLimit;// 购买限制
    private Integer virtualLimitDays;// 购买限制天数
    private Integer virtualMileage;// 虚拟礼品里程
    private BigDecimal virtualPrice;// 虚拟礼品金额
    private Long virtualIntegralLimit;// 积分上限值

}