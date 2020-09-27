package cn.com.cgbchina.batch.model;

import java.io.Serializable;
import java.math.BigDecimal;

import lombok.Getter;
import lombok.Setter;

/**
 * 订单报表数据<br>
 * 日期 : 2016年7月1日<br>
 * 作者 : xiewl<br>
 * 项目 : cgb-trade-api<br>
 * 功能 : <br>
 */
public class OrderBatchModel implements Serializable {

	private static final long serialVersionUID = 8545306024995628546L;
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
	private String bankNbr;
	/**
	 * 受理时间
	 */
	@Getter
	@Setter
	private String acceptedTime;
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
	private Integer stagesNum;
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
	 * 卡标记
	 */
	@Getter
	@Setter
	private String cardType;

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
	 * 证件号码
	 */
	@Getter
	@Setter
	private String contIdcard;
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
	 * 业务类型名称
	 */
	@Getter
	@Setter
	private String ordertypeNm;
	/**
	 * 客户卡号
	 */
	@Getter
	@Setter
	private String cardNo;
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
	 * 客户姓名
	 */
	@Getter
	@Setter
	private String contNm;
	/**
	 * 收货人证件号码
	 */
	@Getter
	@Setter
	private String csgIdcard;
	/**
	 * 卡类
	 */
	@Getter
	@Setter
	private String pdtNbr;

	/**
	 * 省份
	 */
	@Getter
	@Setter
	private String csgProvince;
	/**
	 * 城市
	 */
	@Getter
	@Setter
	private String csgCity;
	/**
	 * 区县
	 */
	@Getter
	@Setter
	private String csgBorough;
	/**
	 * 受理号
	 */
	@Getter
	@Setter
	private String acceptedNo;

	@Getter
	@Setter
	private String goodsName;// 商品名称

	@Getter
	@Setter
	private String vendorName;// 供应商

	/**
	 * 是否为生日(商品退货报表) TBL_GOODS_PAYWAY
	 */
	@Getter
	@Setter
	private String isBirthday;
	/**
	 * 商品编码
	 */
	@Getter
	@Setter
	private String goodsCode;
	
	/**
	 * 礼品分区 (兑换统计月报表) TBL_GOODS
	 */
	@Getter
	@Setter
	private String regionType;

	/**
	 * 一级后台类目
	 */
	@Getter
	@Setter
	private String backCategory1Id;
	/**
	 * 二级后台类目
	 */
	@Getter
	@Setter
	private String backCategory2Id;
	/**
	 * 三级后台类目
	 */
	@Getter
	@Setter
	private String backCategory3Id;
	/**
	 * 邮购分期类别码
	 */
	@Getter
	@Setter
	private String mailOrderCode;
	/**
	 * 分期价格
	 */
	@Getter
	@Setter
	private java.math.BigDecimal installmentPrice;

	/**
	 * 礼品编码
	 */
	@Getter
	@Setter
	private String goodsXid;

	/**
	 * 兑换统计月报表:金普卡
	 */
	@Getter
	@Setter
	private String jpNum;
	/**
	 * 兑换统计月报表:臻享+钛金价格
	 */
	@Getter
	@Setter
	private String ztNum;
	/**
	 * 兑换统计月报表:增值白金+顶级价格
	 */
	@Getter
	@Setter
	private String zdNum;
	/**
	 * 兑换统计月报表:VIP
	 */
	@Getter
	@Setter
	private String vipNum;
	/**
	 * 兑换统计月报表:生日
	 */
	@Getter
	@Setter
	private String birthdayNum;
	/**
	 * 兑换统计月报表:积分+现金
	 */
	@Getter
	@Setter
	private String bcnum;
	/**
	 * 兑换统计月报表:数量总计
	 */
	@Getter
	@Setter
	private String saleSumNum;
	/**
	 * (会员报表)会员总数记录:会员数量
	 */
	@Getter
	@Setter
	private BigDecimal memberNum;

	/**
	 * 请款礼品数量
	 */
	@Getter
	@Setter
	private Integer requestGoodsNum;
	/**
	 * 请款总金额
	 */
	@Getter
	@Setter
	private BigDecimal requestTotalMoney;
	/**
	 * 退货礼品数量
	 */
	@Getter
	@Setter
	private Integer backGoodsNum;
	/**
	 * 退货总金额
	 */
	@Getter
	@Setter
	private BigDecimal backTotalMoney;
	
	@Getter
	@Setter
	private String ordernbr;

	@Getter
	@Setter
	private Long productId;
	
	/**
	 * 品牌
	 */
	@Getter
	@Setter
	private String goodsBrandName;
	
	/**
	 * 客户等级
	 */
	@Getter
	@Setter
	private String custType;
	
	/**
	 * 商品类型
	 */
	@Getter
	@Setter
	private String actType;
	
	/**
	 * 活动名称
	 */
	@Getter
	@Setter
	private String actName;
	
	/**
	 * 采购价
	 */
	@Getter
	@Setter
	private BigDecimal purchasePrice;
	
	
}
