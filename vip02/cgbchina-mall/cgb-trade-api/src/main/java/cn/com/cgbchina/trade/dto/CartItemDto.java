package cn.com.cgbchina.trade.dto;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.List;

import cn.com.cgbchina.item.dto.MallPromotionResultDto;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

/**
 * Created by
 */
@Setter
@Getter
@ToString
public class CartItemDto implements Serializable {

	private static final long serialVersionUID = 3860540595434882226L;
	private Long custCartId;//购物车id
	private String itemImg;//单品图片
	private String goodsName;	//商品名称
	private String itemCode;//单品编码
	private String itemId;//单品id
	private String goodsId;//商品id
	private String ordertypeId;// 订单类型id:分期订单:FQ  一次性订单:YG 积分订单：JF
	private String price;//页面单价 tbl_goods_payway表中 FQ:per_stage 或 YG:goods_price FQ
	private String oriPrice;	//商品原价(满减与积分抵扣优先级调试)
	private java.math.BigDecimal discountMoney;// 积分抵扣金额(满减与积分抵扣优先级调试)
	private String stagesCode;//分期数
	private String goodsNum;//商品数量
	private String oriBonusValue;//原积分抵扣数
	private String bonusValue;//现积分抵扣数
	private List<VoucherInfoDto> voucherInfoDtoList;//优惠券信息 当前商品可以使用的（用户已领取未使用）
	private List<VoucherInfoDto> voucherForGetList; //优惠券信息 当前商品可以领取的（用户无关）

	private String bonusType;//积分类型
	private String cash;//现金(积分商城保留)
	private String exchangeGrade;//兑换等级(积分商城保留)
	private String promName;// 活动名称
	private String promShortName;// 简称
	private Integer promType;// 活动类型 10 折扣 20 满减 30 秒杀 40 团购 50 荷兰拍
	private Integer promotionId;// 活动ID(活动) list
	private String strDiscountPrice;		//页面单价（售价 - 积分抵扣金额）/ 分期数
	private String discountPrice;	//折后价 若等于0 标识全积分支付
	private Boolean promotionFlag;	//商品是否参加活动标识
	private String isFixBonusFlag;	//固定积分标识
	private String pageFixBonusValue;	//固定积分
	private String canChangeNum;		//是否可改变数量
	private String goodsType;		//商品类型（00实物01虚拟02O2O）
	private String userFavoriteFlag;		//单品收藏标识 是否已经收藏（1:收藏 0:未收藏）
	private String effectiveFlag;	//购物车单品有效标识
	private String isVirtualItem;//虚拟商品标识 0 非虚拟(积分商城) 1 虚拟
	private String integral;	//积分(积分商城)
	private String pointsTypeName;	//商品积分类型(积分商城)
//	private java.math.BigDecimal goodsPrice;	//商品价格(积分商城)
	private String exchangeLevelName;	//兑换等级(积分商城)
	private String virtualLimitFlag;	//购买限制(积分商城)
	private String maxUsedBonus;//积分换购商品上限
	private String error;  //错误信息
	private String custmerNm; //用户等级
	private BigDecimal discountPercent; //折扣比例
	private MallPromotionResultDto mallPromotionResult;
}
