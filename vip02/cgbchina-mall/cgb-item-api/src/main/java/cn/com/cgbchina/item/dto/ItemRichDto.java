package cn.com.cgbchina.item.dto;

import cn.com.cgbchina.item.model.ItemModel;
import lombok.Getter;
import lombok.Setter;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 * 单品信息（搜索以单品管理）
 *
 * Created by 11140721050130 on 2016/9/5.
 */
@Getter
@Setter
public class ItemRichDto extends ItemModel {
    private String goodsType;// 商品类型
    private Iterable<Long> categoryIds;  //后台类目1-3级
    private Iterable<Long> attributeIds;
    private String name;
    private String ordertypeId;// 业务类型代码YG：广发JF：积分
    private Long goodsPoint;//积分数量
    private Long backCategory1Id;// 一级后台类目
    private Long backCategory2Id;// 二级后台类目
    private Long backCategory3Id;// 三级后台类目
    private Long productId;// 产品id
    private String createType;// 创建类型0平台创建1供应商创建
    private String vendorId;// 供应商id
    private String vendorName; // 供应商名称
    private String manufacturer;// 生产企业
    private Long goodsBrandId;// 品牌id
    private String channelMall;// 广发商城状态0已上架1未上架
    private String channelCc;// CC状态0已上架1未上架
    private String channelMallWx;// 广发商城-微信状态0已上架1未上架
    private String channelCreditWx;// 信用卡中心-微信状态0已上架1未上架
    private String channelPhone;// 手机商城状态0已上架1未上架
    private String channelApp;// APP状态0已上架1未上架
    private long channelSms;// 短信状态0已上架1未上架
    private String channelPoints;
    private String channelIvr;
    private Date onShelfMallDate;// 广发商城上架时间
    private Date onShelfCcDate;// cc上架时间
    private Date onShelfMallWxDate;// 广发商城-微信上架时间
    private Date onShelfCreditWxDate;// 信用卡中心-微信上架时间
    private Date onShelfPhoneDate;// 手机商城上架时间
    private Date onShelfAppDate;// app上架时间
    private Date onShelfSmsDate;// 短信上架时间
    private String mallShelfStatus;// 广发商城状态0已上架1未上架
    private String ccShelfStatus;// CC状态0已上架1未上架
    private String mallWxShelfStatus;//广发商城-微信状态0已上架1未上架
    private String creditWxShelfStatus;// 信用卡中心-微信状态0已上架1未上架
    private String phoneShelfStatus;// 手机商城状态0已上架1未上架
    private String appShelfStatus;//APP状态0已上架1未上架
    private String smsShelfStatus;//短信状态0已上架1未上架

    private Integer mallPromoType = 0;// 广发商城活动类型
    private Integer ccPromoType = 0;// CC活动类型
    private Integer mallWxPromoType = 0;//广发商城-微信活动类型
    private Integer creditWxPromoType = 0;// 信用卡中心-微信活动类型
    private Integer phonePromoType = 0;// 手机商城活动类型
    private Integer appPromoType = 0;//APP活动类型
    private Integer smsPromoType = 0;//短信活动类型
    private Integer ivrPromoType = 0;//短信活动类型

    private String isInner;// 是否内宣商品0是1否
    private Long salesNum; //销量
    private List<Map<String, Object>> saleAttrList;//销售属性 eg:[{"attrId":"12attr30"},{"attrId":"12attr60"}]
    private java.util.Date onShelfPointsDate;//积分商城上架时间
    private java.util.Date offShelfPointsDate;//积分商城下架时间
    private java.util.Date onShelfIvrDate;
    private java.util.Date offShelfIvrDate;
    private String installmentNumber;
    private BigDecimal totalPrice;//商品总价,price字段为分期后的价格
    private String regionType;// 分区(礼品用)

    private Long points;//广发商城的最大积分兑换  积分商城的积分

    private BigDecimal originalPrice;//原始分期价
    //itemModel中，对于搜索的运用，price字段，如果商品有活动价Price字段就是活动价，如果没有活动价，price字段就是原始价格，
    // 而originalPrice永远是原始价格，用于区分不同渠道活动状态不同搜索结果页价格不同的问题
    private BigDecimal originalTotalPrice;//原始总价
    private Long originalPoints;//原始积分

    private Long tjPoints;//0001 钛金/臻享白金
    private Long djPoints;//0002 顶级/增值白金
    private Long vipPoints;//0003 VIP
    private Long birthPoints;//0004 生日
    private Long jfPoints;//积分
    private BigDecimal xjPrice;//现金



}
