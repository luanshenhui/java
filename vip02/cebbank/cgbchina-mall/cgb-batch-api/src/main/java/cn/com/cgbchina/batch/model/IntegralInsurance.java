package cn.com.cgbchina.batch.model;

import java.io.Serializable;
import java.math.BigDecimal;

import lombok.Getter;
import lombok.Setter;

/**
 * 保险积分兑换 用于报表： 1、积分兑换报表（中国人寿保险标准卡旅行意外） 2、积分兑换报表（中国人寿保险标准卡重大疾病） 3、积分兑换报表（中国人寿保险真情卡女性疾病） 4、积分兑换报表（中国人寿保险真情卡旅行意外）
 * 5、积分兑换报表（中国人寿保险真情卡重大疾病） 6、积分兑换报表（中国人寿保险真情卡购物保障） 7、积分兑换报表（中国人寿保险车主卡驾驶员意外） 8、积分兑换报表（中国人民财产保险车主卡旅行交通意外）
 * 9、积分兑换报表（爱·宠普卡宠物饲养责任保险） Created by huangcy on 2016-5-4.
 */
public class IntegralInsurance implements Serializable {
	private static final long serialVersionUID = 1L;

	/** 序号 */
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

	/** 客户证件 */
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

	/** 单价 */
	@Getter
	@Setter
	private BigDecimal singlePrice;

	/** 金额 */
	@Getter
	@Setter
	private BigDecimal money;

	/** 卡类 */
	@Getter
	@Setter
	private String pdtNbr;

	/** 备注 */
	@Getter
	@Setter
	private String remark;

}
