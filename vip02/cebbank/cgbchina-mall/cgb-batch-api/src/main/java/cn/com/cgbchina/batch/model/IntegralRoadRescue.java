package cn.com.cgbchina.batch.model;

import java.io.Serializable;

import lombok.Getter;
import lombok.Setter;

/**
 * 积分兑换周报表（易车公司车主卡道路救援） Created by huangcy on 2016-5-4.
 */
public class IntegralRoadRescue implements Serializable {
	private static final long serialVersionUID = 1L;

	/** 持卡人姓名 */
	@Getter
	@Setter
	private String contNm;

	/** 证件号码 */
	@Getter
	@Setter
	private String contIdCard;

	/** 卡号 */
	@Getter
	@Setter
	private String cardNo;

	/** 下单日期+1 */
	@Getter
	@Setter
	private String beginDate;

	/** 下单日期 + 1年 */
	@Getter
	@Setter
	private String endDate;

}
