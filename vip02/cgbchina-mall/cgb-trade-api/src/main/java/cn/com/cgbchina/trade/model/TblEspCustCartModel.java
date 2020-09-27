package cn.com.cgbchina.trade.model;

import cn.com.cgbchina.item.model.ItemModel;
import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.List;

public class TblEspCustCartModel implements Serializable {

    @Getter
    @Setter
    private Long id;//自增主键
    @Getter
    @Setter
    private String custId;//客户id
    @Getter
    @Setter
    private String itemId;//单品id
    @Getter
    @Setter
    private String goodsPaywayId;//付款方式id
    @Getter
    @Setter
    private String goodsType;//付款方式id
    @Getter
    @Setter
    private String goodsNum;//商品数量
    @Getter
    @Setter
    private java.util.Date addTime;//新增时间
    @Getter
    @Setter
    private String payFlag;//付款方式
    @Getter
    @Setter
    private String ordertypeId;//订单类型id:分期订单:FQ  一次性订单:YG 积分订单：JF
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
    private String entryCard;//附属卡号
    @Getter
    @Setter
    private Long bonusValue;//积分抵扣数
    @Getter
    @Setter
    private Long singlePoint;//单位积分
    @Getter
    @Setter
    private String cardType;//卡类型 1：信用卡；2借记卡
    @Getter
    @Setter
    private String attachIdentityCard;//留学生意外险附属卡证件号码
    @Getter
    @Setter
    private String attachName;//留学生意外险附属卡姓名
    @Getter
    @Setter
    private String prepaidMob;//充值电话号码
    @Getter
    @Setter
    private Long oriBonusValue;//抵扣积分
    @Getter
    @Setter
    private String serialno;//客户所输入的保单号
    @Getter
    @Setter
    private Long fixBonusValue;//固定积分
    @Getter
    @Setter
    private List<ItemModel> ItemList;//购物车对应单品
    @Getter
    @Setter
    private String voucherId;//优惠券Id
    @Getter
    @Setter
    private String voucherNo;//优惠券No
    @Getter
    @Setter
    private String voucherName;//优惠券名称
    @Getter
    @Setter
    private BigDecimal voucherPrice;//优惠券金额
    @Getter
    @Setter
    private String custmerNm; //用户等级名称
}