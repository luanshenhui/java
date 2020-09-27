package cn.com.cgbchina.batch.model;

import java.io.Serializable;
import java.math.BigDecimal;

import lombok.Getter;
import lombok.Setter;

/**
 * (供应商平台)商户销售明细报表 用于报表:1.商户销售明细报表(日) 2.商户销售明细报表(周) 3.商户销售明细报表(月) Created by huangcy on 2016-5-4.
 */
public class VendorSellDetail implements Serializable {
	/**
	 * 子订单号
	 */
	@Getter
	@Setter
	private String orderId;

	/**
	 * 商品编号
	 */
	@Getter
	@Setter
	private String goodsId;

	/**
	 * 商品名称
	 */
	@Getter
	@Setter
	private String goodsNm;
	/**
	 * 商品一级分类
	 */
	@Getter
	@Setter
	private String backCategory1;
	/**
	 * 商品二级分类
	 */
	@Getter
	@Setter
	private String backCategory2;
	/**
	 * 商品三级分类
	 */
	@Getter
	@Setter
	private String backCategory3;
	/**
	 * 商品四级分类
	 */
	@Getter
	@Setter
	private String backCategory4;

	/**
	 * 销售数量
	 */
	@Getter
	@Setter
	private int goodsNum;

	/**
	 * 售价
	 */
	@Getter
	@Setter
	private BigDecimal singlePrice;

	/**
	 * 合作商
	 */
	@Getter
	@Setter
	private String vendorSnm;

	/**
	 * 卡类
	 */
	@Getter
	@Setter
	private String pdtNbr;

	/**
	 * 卡号后四位
	 */
	@Getter
	@Setter
	private String cardNo;

	/**
	 * 类型
	 */
	@Getter
	@Setter
	private String type;

	/**
	 * 订单状态
	 */
	@Getter
	@Setter
	private String curStatusNm;

	/**
	 * 渠道
	 */
	@Getter
	@Setter
	private String sourceNm;

	/**
	 * 邮购分期类别码
	 */
	@Getter
	@Setter
	private String specShopNo;

	/**
	 * 优惠券编号
	 */
	@Getter
	@Setter
	private String voucherNo;

	/**
	 * 优惠券名称
	 */
	@Getter
	@Setter
	private String voucherNm;

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
	private int bonusTotalValue;

	/**
	 * 积分抵扣金额
	 */
	@Getter
	@Setter
	private BigDecimal bonusPrice;

}
