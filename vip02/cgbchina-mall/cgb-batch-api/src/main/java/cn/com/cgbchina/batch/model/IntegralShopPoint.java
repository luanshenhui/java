package cn.com.cgbchina.batch.model;

import java.io.Serializable;

import lombok.Getter;
import lombok.Setter;

/**
 * 积分兑换周报表（购物积点） Created by huangcy on 2016-5-4.
 */
public class IntegralShopPoint implements Serializable {
	private static final long serialVersionUID = 1L;

	@Getter
	@Setter
	private int id;

	/* 下单时间 */
	@Getter
	@Setter
	private String acceptDate;

	/* 子订单号 */
	@Getter
	@Setter
	private String acceptNo;

	@Getter
	@Setter
	private String custName;

	@Getter
	@Setter
	private String cardNo;

	/* 客户手动输入 */
	@Getter
	@Setter
	private String memberId;

	@Getter
	@Setter
	private String goodsXid;

	@Getter
	@Setter
	private String goodsName;

	/* 换领积分数：单个礼品积分*数量 */
	@Getter
	@Setter
	private int integralNum;

	/* 换领积分数：3*数量 */
	@Getter
	@Setter
	private int pointNum;

	@Getter
	@Setter
	private String remark;

}
