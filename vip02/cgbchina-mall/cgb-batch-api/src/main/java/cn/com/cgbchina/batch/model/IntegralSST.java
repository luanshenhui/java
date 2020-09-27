package cn.com.cgbchina.batch.model;

import java.io.Serializable;

import lombok.Getter;
import lombok.Setter;

/**
 * 积分兑换周报表（录入组瞬时通） Created by huangcy on 2016-5-4.
 */
public class IntegralSST implements Serializable {
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

	/** 证件号码 */
	@Getter
	@Setter
	private String contIdCard;

	/** 卡号 */
	@Getter
	@Setter
	private String cardNo;

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

	/** 手机号码 */
	@Getter
	@Setter
	private String contMobPhone;

	/** 备注 */
	@Getter
	@Setter
	private String remark;

}
