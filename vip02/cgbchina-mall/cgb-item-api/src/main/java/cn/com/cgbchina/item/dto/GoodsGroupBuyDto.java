package cn.com.cgbchina.item.dto;

import java.io.Serializable;

import lombok.Getter;
import lombok.Setter;

/**
 * 团购商品 geshuo 20160705
 */
public class GoodsGroupBuyDto implements Serializable {

	private static final long serialVersionUID = -6029559323082241013L;
	// 商品编码（商品表）
	@Setter
	@Getter
	private String goodsCode;

	// 单品编码
	@Setter
	@Getter
	private String itemCode;

	// 图片（单品表）
	@Setter
	@Getter
	private String goodsImg;

	// 价格（单品表）
	@Setter
	@Getter
	private String groupPrice;

	// 分期数（商品表 ）
	@Setter
	@Getter
	private String installmentNumber;

	// 商品名称（商品表）
	@Setter
	@Getter
	private String goodsName;

	// 已付款件数（订单详细表）
	@Setter
	@Getter
	private String buyCount;

	// 活动结束时间
	@Setter
	@Getter
	private Boolean expired;
}
