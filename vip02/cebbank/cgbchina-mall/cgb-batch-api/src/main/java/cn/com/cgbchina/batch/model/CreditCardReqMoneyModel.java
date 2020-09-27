package cn.com.cgbchina.batch.model;

import java.io.Serializable;
import java.math.BigDecimal;

import lombok.Getter;
import lombok.Setter;

/**
 * 信用卡请款对账明细报表 用于： 1、信用卡请款对账明细日报表 2、信用卡请款对账明细月报表 3、信用卡请款对账明细周报表 Created by huangcy on 2016-5-4.
 */
public class CreditCardReqMoneyModel implements Serializable {
	/**
	 * 序号
	 */
	@Getter
	@Setter
	private String index;
	/**
	 * 订单号
	 */
	@Getter
	@Setter
	private String orderId;

	/**
	 * 银行订单号
	 */
	@Getter
	@Setter
	private String bankNBR;

	/**
	 * 商品编号
	 */
	@Getter
	@Setter
	private String goodsId;

	/**
	 * 商品名称
	 */
	@Getter
	@Setter
	private String goodsNm;

	/**
	 * 售价
	 */
	@Getter
	@Setter
	private BigDecimal singlePrice;

	/**
	 * 期数
	 */
	@Getter
	@Setter
	private int stageNum;

	/**
	 * 积分
	 */
	@Getter
	@Setter
	private BigDecimal singleBonus;

	/**
	 * 优惠券编号
	 */
	@Getter
	@Setter
	private String voucherNo;

	/**
	 * 邮购分期类别码
	 */
	@Getter
	@Setter
	private String specShopNo;
}
