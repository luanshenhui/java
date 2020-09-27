package cn.com.cgbchina.item.dto;

import java.io.Serializable;

import lombok.Getter;
import lombok.Setter;

/**
 * 拍卖纪录
 *
 * @author huangfuchangyu
 * @version 1.0
 * @Since 2016/7/20
 */
public class AuctionRecordDto implements Serializable {
	private static final long serialVersionUID = 2781082178466313570L;
	@Getter
	@Setter
	private Long id;// 自增主键
	@Getter
	@Setter
	private String custId;// 客户ID
	@Getter
	@Setter
	private String cell;// 客户手机号
	@Getter
	@Setter
	private String cardno;// 卡号
	@Getter
	@Setter
	private String orderId;// 订单号
	@Getter
	@Setter
	private String itemId;// 单品ID
	@Getter
	@Setter
	private String goodsNm;// 商品名称
	@Getter
	@Setter
	private String goodsPaywayId;// 支付方式ID
	@Getter
	@Setter
	private java.math.BigDecimal auctionPrice;// 拍卖价格
	@Getter
	@Setter
	private java.util.Date auctionTime;// 拍卖时间
	@Getter
	@Setter
	private Long auctionId;// 活动ID
	@Getter
	@Setter
	private Integer periodId;// 活动场次ID
	@Getter
	@Setter
	private String isBacklock;// 是否锁定库存
	@Getter
	@Setter
	private String payFlag;// 是否完成支付
	@Getter
	@Setter
	private java.util.Date beginPayTime;// 开始支付时间
	@Getter
	@Setter
	private java.util.Date releaseTime;// 释放库存时间
	@Getter
	@Setter
	private java.util.Date modifyTime;// 修改时间
}
