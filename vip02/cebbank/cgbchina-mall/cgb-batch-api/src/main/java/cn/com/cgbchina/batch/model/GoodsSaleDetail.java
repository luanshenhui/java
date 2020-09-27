package cn.com.cgbchina.batch.model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;

import lombok.Getter;
import lombok.Setter;

/**
 * 商品销售明细 用于报表:1.商品销售明细日报表 2.商品销售明细周报表 3.商品销售明细月报表
 * 
 * @author xiewl
 * @version 2016年5月4日 下午3:25:32
 */
public class GoodsSaleDetail implements Serializable {

	private static final long serialVersionUID = 1L;

	public GoodsSaleDetail() {

	}

	/**
	 * 序号
	 */
	@Getter
	@Setter
	private String index;

	/**
	 * 受理号
	 */
	@Getter
	@Setter
	private String acceptedNo;
	/**
	 * 商城订单号
	 */
	@Getter
	@Setter
	private String orderId;
	/**
	 * 银行订单号
	 */
	@Getter
	@Setter
	private String orderNBR;
	/**
	 * 受理时间
	 */
	@Getter
	@Setter
	private Date acceptedTime;
	/**
	 * 客户卡号
	 */
	@Getter
	@Setter
	private String cardNo;
	/**
	 * 渠道
	 */
	@Getter
	@Setter
	private String sourceNm;
	/**
	 * 合作商
	 */
	@Getter
	@Setter
	private String vendorSnm;
	/**
	 * 商品编号
	 */
	@Getter
	@Setter
	private String goodsId;
	/**
	 * 支付类型
	 */
	@Getter
	@Setter
	private String paywayNm;
	/**
	 * 期数
	 */
	@Getter
	@Setter
	private Integer installmentNum;
	/**
	 * 申请金额
	 */
	@Getter
	@Setter
	private BigDecimal totalMoney;
	/**
	 * 申请数量
	 */
	@Getter
	@Setter
	private Integer goodsNum;
	/**
	 * 送货地址
	 */
	@Getter
	@Setter
	private String csgAddress;
	/**
	 * 送货邮编
	 */
	@Getter
	@Setter
	private String csgPostcode;
	/**
	 * 手机号码
	 */
	@Getter
	@Setter
	private String csgPhone1;
	/**
	 * 固话
	 */
	@Getter
	@Setter
	private String csgPhone2;
	/**
	 * 发票抬头
	 */
	@Getter
	@Setter
	private String invoice;
	/**
	 * 邮购分期类别码
	 */
	@Getter
	@Setter
	private String specShopNo;
	/**
	 * 优惠券子编号
	 */
	@Getter
	@Setter
	private String voucherNo;
	/**
	 * 优惠券名称
	 */
	@Getter
	@Setter
	private String vouvherNm;
	/**
	 * 优惠券抵扣金额
	 */
	@Getter
	@Setter
	private BigDecimal voucherPrice;
	/**
	 * 使用积分
	 */
	@Getter
	@Setter
	private Long bonusTotalValue;
	/**
	 * 积分抵扣金额
	 */
	@Getter
	@Setter
	private BigDecimal bonusPrice;

}
