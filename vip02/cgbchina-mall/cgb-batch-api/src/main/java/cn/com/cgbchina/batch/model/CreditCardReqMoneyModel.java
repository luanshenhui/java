package cn.com.cgbchina.batch.model;

import java.io.Serializable;
import java.math.BigDecimal;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

/**
 * 信用卡请款对账明细报表 用于： 1、信用卡请款对账明细日报表 2、信用卡请款对账明细月报表 3、信用卡请款对账明细周报表 Created by huangcy on 2016-5-4.
 */
@Setter
@Getter
@ToString
public class CreditCardReqMoneyModel implements Serializable {
	private static final long serialVersionUID = -7955847054958303228L;
	/**
	 * 序号
	 */
	private String index;
	/**
	 * 订单号
	 */
	private String orderId;

	/**
	 * 银行订单号
	 */
	private String bankNBR;

	/**
	 * 商品编号
	 */
	private String goodsId;

	/**
	 * 商品名称
	 */
	private String goodsNm;

	/**
	 * 售价
	 */
	private BigDecimal singlePrice;

	/**
	 * 期数
	 */
	private int stageNum;

	/**
	 * 积分
	 */
	private BigDecimal singleBonus;

	/**
	 * 优惠券编号
	 */
	private String voucherNo;

	/**
	 * 邮购分期类别码
	 */
	private String specShopNo;
}
