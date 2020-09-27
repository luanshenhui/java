package cn.com.cgbchina.batch.model;

import java.io.Serializable;

import lombok.Getter;
import lombok.Setter;

/**
 * 积分兑换周报表（南航里程） Created by huangcy on 2016-5-4.
 */
public class IntegralAirlineMileage implements Serializable {
	private static final long serialVersionUID = 1L;

	@Getter
	@Setter
	private Integer id;

	/** 受理时间 */
	@Getter
	@Setter
	private String bonusTrnTime;

	/** 受理号 */
	@Getter
	@Setter
	private String orderId;

	/** 客户姓名 */
	@Getter
	@Setter
	private String custName;

	/** 客户卡号 */
	@Getter
	@Setter
	private String cardNo;

	/** 明珠会员号 */
	@Getter
	@Setter
	private String memberId;

	/** 礼品代号 */
	@Getter
	@Setter
	private String goodsId;

	/** 礼品名称 */
	@Getter
	@Setter
	private String goodsNm;

	/** 换领里程数 */
	@Getter
	@Setter
	private Integer allMileage;

	/** 手机号码 */
	@Getter
	@Setter
	private String contMobPhone;

	/** 备注 */
	@Getter
	@Setter
	private String remark;

}
