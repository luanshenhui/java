package cn.com.cgbchina.batch.model;

import java.io.Serializable;
import java.math.BigDecimal;

import lombok.Getter;
import lombok.Setter;

/**
 * 商户销售明细 （广发商城） 用于报表:1.商户销售明细报表(日) 2.商户销售明细报表(周) 3.商户销售明细报表(月)
 * @author xiewl
 * @version 2016年5月4日 下午4:01:05
 */
public class VendorSaleDetail implements Serializable {

	private static final long serialVersionUID = -6794059135532342930L;

	/**
	 * 子订单号
	 */
	@Getter
	@Setter
	private String orderId;

	/**
	 * 商品编码
	 */
	@Getter
	@Setter
	private String goodsCode;
	/**
	 * 商品名称
	 */
	@Getter
	@Setter
	private String goodsName;
	/**
	 * 一级类目
	 */
	@Getter
	@Setter
	private Integer category1Id;
	/**
	 * 二级类目
	 */
	@Getter
	@Setter
	private Integer category2Id;

	/**
	 * 三级类目
	 */
	@Getter
	@Setter
	private Integer category3Id;
	/**
	 * 销售数量
	 */
	@Getter
	@Setter
	private Integer goodsNum;
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
	 * 订单状态
	 */
	@Getter
	@Setter
	private String curStatusId;
	/**
	 * 渠道
	 */
	@Getter
	@Setter
	private String sourceName;
	/**
	 * 邮购分期类别码
	 */
	@Getter
	@Setter
	private String mailOrderCode;
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
	private Long bonusTotalvalue;
	/**
	 * 积分抵扣金额
	 */
	@Getter
	@Setter
	private BigDecimal bonusPrice;

}
