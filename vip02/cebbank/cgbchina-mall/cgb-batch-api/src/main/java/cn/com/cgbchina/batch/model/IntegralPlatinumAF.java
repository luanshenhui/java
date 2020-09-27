package cn.com.cgbchina.batch.model;

import java.io.Serializable;
import java.math.BigDecimal;

import lombok.Getter;
import lombok.Setter;

/**
 * 积分兑换周报表（白金卡换年费） Created by huangcy on 2016-5-4.
 */
public class IntegralPlatinumAF implements Serializable {
	private static final long serialVersionUID = 1L;

	@Getter
	@Setter
	private int id;

	/** 客户姓名 */
	@Getter
	@Setter
	private String contNm;

	/** 证件号 */
	@Getter
	@Setter
	private String contIdCard;

	/** 卡号 */
	@Getter
	@Setter
	private String cardNo;

	/** 兑换时间 */
	@Getter
	@Setter
	private String bonusTrnDate;

	/** 子订单号 */
	@Getter
	@Setter
	private String orderId;

	/** 礼品编号 */
	@Getter
	@Setter
	private String goodsId;

	/** 扣减积分 */
	@Getter
	@Setter
	private Long bonusTotalValue;

	/** 礼品名称 */
	@Getter
	@Setter
	private String goodsNm;

	/** 兑换金额 */
	@Getter
	@Setter
	private BigDecimal bonusPrice;

}
