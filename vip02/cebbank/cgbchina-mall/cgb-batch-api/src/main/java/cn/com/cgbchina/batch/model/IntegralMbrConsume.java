package cn.com.cgbchina.batch.model;

import java.io.Serializable;

import lombok.Getter;
import lombok.Setter;

/**
 * 积分兑换周报表（ALL常旅客会员消费） Created by huangcy on 2016-5-4.
 */
public class IntegralMbrConsume implements Serializable {
	private static final long serialVersionUID = 1L;

	/** 序号 */
	@Getter
	@Setter
	private Integer id;

	/** 订单号 */
	@Getter
	@Setter
	private String orderId;

	/** 航空类型 */
	@Getter
	@Setter
	private String aviationType;

	/** 航空会员 */
	@Getter
	@Setter
	private String memberId;

	/** 会员姓名（中文） */
	@Getter
	@Setter
	private String contNm;

	/** 会员姓名（英文） */
	@Getter
	@Setter
	private String engName;

	/** 信用卡号 */
	@Getter
	@Setter
	private String cardNo;

	/** 手机号码 */
	@Getter
	@Setter
	private String contMobPhone;

	/** 消费时间 */
	@Getter
	@Setter
	private String createTime;

	/** 礼品编号 */
	@Getter
	@Setter
	private String goodsId;

	/** 礼品名称 */
	@Getter
	@Setter
	private String goodsNm;

	/** 里程数 */
	@Getter
	@Setter
	private Integer mileage;

	/** 积分数 */
	@Getter
	@Setter
	private Long bonusTotalValue;

	/** 经办人 */
	@Getter
	@Setter
	private String operator;

	/** 经办单位 */
	@Getter
	@Setter
	private String operUnit;

	/** 卡版描述 */
	@Getter
	@Setter
	private String pdtNbr;
}
