package cn.com.cgbchina.trade.model;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;

/**
 * Created by 11141021040453 on 16-4-15.
 */
public class OrderInfo implements Serializable {

	private static final long serialVersionUID = 8592954912629855010L;

	@Getter
	@Setter
	private String hostId;// 主订单编号

	@Getter
	@Setter
	private String id;// 订单编号

	@Getter
	@Setter
	private String number;//

	@Getter
	@Setter
	private Date time;// 下单时间

	@Getter
	@Setter
	private String type;// 订单类型

	@Getter
	@Setter
	private String channel;// 渠道

	@Getter
	@Setter
	private String customer;// 顾客名称

	@Getter
	@Setter
	private BigDecimal orderSum;// 订单金额

	@Getter
	@Setter
	private String serviceStatus;// 售后

	@Getter
	@Setter
	private BigDecimal payment;// 实际支付

	@Getter
	@Setter
	private String instalentsStatus;// 分期详细信息

	@Getter
	@Setter
	private int sum;// 数量

	@Getter
	@Setter
	private String dealStatus;// 交易状态

	@Getter
	@Setter
	private Merchandise merchandise;// 商品信息

	@Getter
	@Setter
	private String stage;// 分期

	@Getter
	@Setter
	private BigDecimal stageSum;// 每期金额

	@Getter
	@Setter
	private BigDecimal coupon;// 优惠券

	@Getter
	@Setter
	private BigDecimal points;// 积分

	@Getter
	@Setter
	private String seller;// 供应商

	@Getter
	@Setter
	private BuyerInfo buyerInfo;// 收货人信息

	@Getter
	@Setter
	private Transportation transportation;// 物流信息
	@Getter
	@Setter
	private String flag;// 审核状态
}
