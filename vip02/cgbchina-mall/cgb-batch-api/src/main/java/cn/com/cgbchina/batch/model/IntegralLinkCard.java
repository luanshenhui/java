package cn.com.cgbchina.batch.model;

import java.io.Serializable;

import lombok.Getter;
import lombok.Setter;

/**
 * 积分兑换周报表（联通卡） Created by huangcy on 2016-5-4.
 */
public class IntegralLinkCard implements Serializable {
	private static final long serialVersionUID = 1L;

	@Getter
	@Setter
	private Integer id;

	/** 受理号 */
	@Getter
	@Setter
	private String orderId;

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

	/** 证件号码 */
	@Getter
	@Setter
	private String contIdCard;

	/** 手机号码 */
	@Getter
	@Setter
	private String contMobPhone;

	/** 客户姓名 */
	@Getter
	@Setter
	private String contNm;

	/** 根据卡号8、9位获取分行号对应的发卡城市 */
	@Getter
	@Setter
	private String cardCity;

	/** 供应商 */
	@Getter
	@Setter
	private String vendorSnm;

}
