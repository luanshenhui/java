package cn.com.cgbchina.trade.dto;

import java.io.Serializable;

import lombok.Getter;
import lombok.Setter;

/**
 * 报表 订单报表商品信息
 * 
 * @author xiewl
 * @version 2016年6月23日 下午2:02:43
 */
public class GoodsDetailBatchDto implements Serializable {
	private static final long serialVersionUID = -3376779245711987825L;
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
	private String goodsNm;
	/**
	 * 一级后台类目
	 */
	@Getter
	@Setter
	private Long backCategory1Id;
	/**
	 * 二级后台类目
	 */
	@Getter
	@Setter
	private Long backCategory2Id;
	/**
	 * 三级后台类目
	 */
	@Getter
	@Setter
	private Long backCategory3Id;
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
}
