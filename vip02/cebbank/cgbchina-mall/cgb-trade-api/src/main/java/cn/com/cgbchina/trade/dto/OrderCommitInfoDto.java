/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.trade.dto;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.List;

/**
 * @author jiao.wu
 * @version 1.0
 * @Since 2016/6/1.
 */
public class OrderCommitInfoDto implements Serializable {

	private static final long serialVersionUID = -1691525859191970010L;
	@Getter
	@Setter
	private String code;// 单品编码

	@Getter
	@Setter
	private java.math.BigDecimal price;// 实际价格

	@Getter
	@Setter
	private String image1;// 图片1

	@Getter
	@Setter
	private List<OrderItemAttributeDto> itemAttributeDtoList;// 单品属性list

	@Getter
	@Setter
	private Integer itemCount;// 数量

	@Getter
	@Setter
	private String instalments;// 分期数

	@Getter
	@Setter
	private BigDecimal instalmentsPrice;// 分期金额

	@Getter
	@Setter
	private BigDecimal subTotal;// 小计

	@Getter
	@Setter
	private String goodsName;// 商品名

	@Getter
	@Setter
	private Integer jfCount;// 积分

	@Getter
	@Setter
	private String voucherId;// 优惠券ID
}