package cn.com.cgbchina.trade.dto;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;

import lombok.Getter;
import lombok.Setter;

/**
 * 报表 子订单数据
 * 
 * @author xiewl
 * @version 2016年6月22日 下午2:29:31
 */
public class OrderSubBatchDto implements Serializable {
	private static final long serialVersionUID = -8838394395640720311L;
	/**
	 * 序号
	 */
	@Getter
	@Setter
	private long index;
	/**
	 * 主订单号
	 */
	@Getter
	@Setter
	private String ordermainId;

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
	 * 渠道
	 */
	@Getter
	@Setter
	private String sourceNm;
	/**
	 * 供应商代码
	 */
	@Getter
	@Setter
	private String vendorId;
	/**
	 * 合作商/供应商
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
	 * 商品名称
	 */
	@Getter
	@Setter
	private String goodsNm;
	/**
	 * 支付类型
	 */
	@Getter
	@Setter
	private String paywayNm;
	/**
	 * 发货状态
	 */
	@Getter
	@Setter
	private String goodssendFlag;
	/**
	 * 请款状态
	 */
	@Getter
	@Setter
	private String sinStatusNm;
	/**
	 * 期数
	 */
	@Getter
	@Setter
	private Integer installmentNum;
	/**
	 * 申请金额/ 原始结算价
	 */
	@Getter
	@Setter
	private BigDecimal totalMoney;
	/**
	 * 实际结算价
	 */
	@Getter
	@Setter
	private BigDecimal calMoney;
	/**
	 * 申请数量
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
	 * 邮购分期类别码
	 */
	@Getter
	@Setter
	private String specShopNo;
	/**
	 * 订单状态
	 */
	@Getter
	@Setter
	private String curStatusId;
	/**
	 * 订单状态
	 */
	@Getter
	@Setter
	private String curStatusNm;

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
	/**
	 * 兑换日期
	 */
	@Getter
	@Setter
	private String bonusTrnDate;
	/**
	 * 分期类别码
	 */
	@Getter
	@Setter
	private String ext2;
	/**
	 * 备注
	 */
	@Getter
	@Setter
	private String orderDesc;
	/**
	 * 卡号
	 */
	@Getter
	@Setter
	private String cardNo;
	/**
	 * 客户姓名
	 */
	@Getter
	@Setter
	private String customerNm;
	/**
	 * 证件号码
	 */
	@Getter
	@Setter
	private String certNo;
	/**
	 * 兑换渠道
	 */
	@Getter
	@Setter
	private String otSourceNm;
	/**
	 * 业务日期
	 */
	@Getter
	@Setter
	private String commDate;
	/**
	 * 业务时间
	 */
	@Getter
	@Setter
	private String commTime;
	/**
	 * 物流公司名称
	 */
	@Getter
	@Setter
	private String transcorpNm;
	/**
	 * 货单号
	 */
	@Getter
	@Setter
	private String mailingNum;

	/**
	 * 主订单信息
	 */
	@Getter
	@Setter
	private OrderMainBatchDto orderMainBatchDto;

	/**
	 * 订单商品信息
	 */
	@Getter
	@Setter
	private GoodsDetailBatchDto goodsDetailBatchDto;

	/**
	 * 部分退货信息
	 */
	@Getter
	@Setter
	private OrderPartBackBatchDto orderPartBackBatchDto;
}
