package cn.com.cgbchina.batch.model;

import java.io.Serializable;
import java.math.BigDecimal;

import lombok.Getter;
import lombok.Setter;

/**
 * 积分兑换（新旧聪明卡兑换签帐额）
 * 
 * @author huangcy on 2016年6月3日
 */
public class IntegralSmartCard implements Serializable {
	private static final long serialVersionUID = 1L;

	@Setter
	@Getter
	private Integer id;

	/** 客户姓名 */
	@Setter
	@Getter
	private String contNm;

	/** 证件号 */
	@Setter
	@Getter
	private String contIdCard;

	/** 卡号 */
	@Setter
	@Getter
	private String cardNo;

	/** 兑换时间 */
	@Setter
	@Getter
	private String bonusTrnTime;

	/** 订单号 */
	@Setter
	@Getter
	private String orderId;

	/** 礼品编号 */
	@Setter
	@Getter
	private String goodsId;

	/** 扣减积分 */
	@Setter
	@Getter
	private Long bonusTotalValue;

	/** 礼品名称 */
	@Setter
	@Getter
	private String goodsNm;

	/** 兑换金额 */
	@Setter
	@Getter
	private BigDecimal totalMoney;
}
