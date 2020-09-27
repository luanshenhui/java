package cn.com.cgbchina.trade.dto;

import java.io.Serializable;

import lombok.Getter;
import lombok.Setter;

/**
 * Created by Congzy
 */
@Getter
@Setter
public class CartAddDto implements Serializable {

	private static final long serialVersionUID = 4335985846524116420L;
	private String origin; //渠道 03:如手机商城  00: 网上商城（包括广发，积分商城）CHANNEL_MALL_CODE
	private String mallType;//商城类型 商城类型标识  "01":广发商城 ;"02":积分商城
	private String ordertypeId;//订单类型id:分期订单:FQ  一次性订单:YG 积分订单：JF
	private String custId;//客户id
	private String itemId;//单品id
	private String goodsPaywayId;//付款方式id
	private String goodsNum;//商品数量
	private java.util.Date addTime;//新增时间
	private String payFlag;//付款方式(保留)
	private String virtualMemberId;//会员号(保留)
	private String virtualMemberNm;//会员姓名(保留)
	private String virtualAviationType;//航空类型(保留)
	private String entryCard;//附属卡号(保留)
	private Long bonusValue;//积分抵扣数
	private Long singlePoint;//单位积分
	private String cardType;//卡类型 1：信用卡；2借记卡
	private String attachIdentityCard;//留学生意外险附属卡证件号码(保留)
	private String attachName;//留学生意外险附属卡姓名(保留)
	private String prepaidMob;//充值电话号码(保留)
	private Long oriBonusValue;//抵扣积分
	private String serialno;//客户所输入的保单号(保留)
	private Long fixBonusValue;//固定积分
	private String custmerNm; //用户等级名称
}
