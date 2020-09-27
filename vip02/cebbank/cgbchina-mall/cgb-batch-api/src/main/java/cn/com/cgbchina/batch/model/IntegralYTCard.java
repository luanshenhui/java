package cn.com.cgbchina.batch.model;

import java.io.Serializable;
import java.math.BigDecimal;

import lombok.Getter;
import lombok.Setter;

/**
 * 积分兑换周报表（人保粤通卡积分兑换） Created by huangcy on 2016-5-4.
 */
public class IntegralYTCard implements Serializable {
	private static final long serialVersionUID = 1L;

	@Getter
	@Setter
	private int id;

	/** 下单时间 */
	@Getter
	@Setter
	private String bonusTrnTime;

	/** 子订单号 */
	@Getter
	@Setter
	private String orderId;

	/** 客户姓名 */
	@Getter
	@Setter
	private String contNm;

	/** 客户证件，证件号码后6位 */
	@Getter
	@Setter
	private String contIdCard;

	/** 礼品代号 */
	@Getter
	@Setter
	private String goodsId;

	/** 礼品名称 */
	@Getter
	@Setter
	private String goodsNm;

	/** 数量 */
	@Getter
	@Setter
	private Integer goodsNum;

	/** 价格 */
	@Getter
	@Setter
	private BigDecimal singlePrice;

	/** 金额 */
	@Getter
	@Setter
	private BigDecimal bonusPrice;

	/** 保单号 */
	@Getter
	@Setter
	private String serialNo;

	@Getter
	@Setter
	private String remark;

}
