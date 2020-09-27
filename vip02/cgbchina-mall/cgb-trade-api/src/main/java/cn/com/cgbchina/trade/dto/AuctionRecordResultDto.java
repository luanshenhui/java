package cn.com.cgbchina.trade.dto;

import java.io.Serializable;
import java.math.BigDecimal;

import lombok.Getter;
import lombok.Setter;

/**
 * Created by wangqi on 16-7-28.
 */
public class AuctionRecordResultDto implements Serializable {

	private static final long serialVersionUID = 7831708519174827609L;

	@Getter
	@Setter
	private String custId;//客户ID
	@Getter
	@Setter
	private String cell;//客户手机号
	@Getter
	@Setter
	private String cardno;//卡号
	@Getter
	@Setter
	private String orderId;//订单号
	@Getter
	@Setter
	private String itemId;//单品ID
	@Getter
	@Setter
	private String goodsNm;//商品名称
	@Getter
	@Setter
	private String goodsPaywayId;//支付方式ID
	@Getter
	@Setter
	private java.math.BigDecimal auctionPrice;//拍卖价格
	@Getter
	@Setter
	private java.util.Date auctionTime;//拍卖时间
	@Getter
	@Setter
	private Long auctionId;//活动ID
	@Getter
	@Setter
	private Integer periodId;//活动场次ID

}
