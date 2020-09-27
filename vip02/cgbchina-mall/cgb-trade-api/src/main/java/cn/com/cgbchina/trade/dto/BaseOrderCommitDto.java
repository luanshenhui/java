package cn.com.cgbchina.trade.dto;

import cn.com.cgbchina.item.dto.MallPromotionResultDto;
import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.List;

/**
 * Created by lvzd on 2016/9/25.
 */
public class BaseOrderCommitDto implements Serializable {

    private static final long serialVersionUID = 1L;

    @Getter
    @Setter
    private String code;// 单品编码

    @Getter
    @Setter
    private String mid;// 商品ID(分期唯一值用于外系统)

    @Getter
    @Setter
    private String payWayId;// 支付方式Id

    @Getter
    @Setter
    private java.math.BigDecimal oriPrice;// 原始价格

    @Getter
    @Setter
    private java.math.BigDecimal price;// 实际价格

    @Getter
    @Setter
    private String image1;// 图片1

    @Getter
    @Setter
    private List<OrderItemAttributeDto> itemAttributeDtoList;// 单品属性list

    @Getter
    @Setter
    private Integer itemCount;// 数量

    @Getter
    @Setter
    private String instalments;// 分期数

    @Getter
    @Setter
    private BigDecimal instalmentsPrice;// 分期金额

    @Getter
    @Setter
    private BigDecimal disInstalmentsPrice;// 积分抵扣后分期金额

    @Getter
    @Setter
    private BigDecimal subTotal;// 小计

    @Getter
    @Setter
    private String goodsName;// 商品名

    @Getter
    @Setter
    private Long singlePrice;// 单位积分 备注：一元钱对应的积分数

    @Getter
    @Setter
    private Long jfCount;// 积分 备注：购买该商品的积分总

    @Getter
    @Setter
    private Long afterDiscountJf;// 折扣后积分

    @Getter
    @Setter
    private BigDecimal discountPercent;// 折扣比例

    @Getter
    @Setter
    private String voucherId;// 优惠券ID

    @Getter
    @Setter
    private String voucherNo;// 优惠券No

    @Getter
    @Setter
    private BigDecimal voucherPrice;// 优惠金额

    @Getter
    @Setter
    private String voucherNm;// 优惠名称

    @Getter
    @Setter
    private boolean fixFlag;// 是否是固定积分

    @Getter
    @Setter
    private MallPromotionResultDto promotion;// 活动信息

    @Getter
    @Setter
    private String cartId ;// 购物车Id

    @Getter
    @Setter
    private String jfType ;// 积分类型

    @Getter
    @Setter
    private String jfTypeName ;//积分类型名

    @Getter
    @Setter
    private String changeLevel ;// 兑换等级

    @Getter
    @Setter
    private BigDecimal mjDisPrice;// 满减金额

    @Getter
    @Setter
    private String cardType;
    @Getter
    @Setter
    private String cardFormat;//卡板

    @Getter
    @Setter
    private String miaoFlag;// 0元秒杀标志
    @Getter
    @Setter
    private String entryCard;//附属卡号
    @Getter
    @Setter
    private String goodsCode;

    @Getter
    @Setter
    private String custmerNm; //用户等级名称
    @Getter
    @Setter
    private String serialno;//客户所输入的保单号

    @Getter
    @Setter
    private String virtualMemberId;//会员号
    @Getter
    @Setter
    private String virtualMemberNm;//会员姓名
    @Getter
    @Setter
    private String virtualAviationType;//航空类型
    @Getter
    @Setter
    private String attachIdentityCard;//留学生意外险附属卡证件号码
    @Getter
    @Setter
    private String attachName;//留学生意外险附属卡姓名
}
