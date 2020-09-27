package cn.com.cgbchina.item.dto;

import java.io.Serializable;

import lombok.Getter;
import lombok.Setter;

/**
 * @author wenjia.hao
 * @version 1.0
 * @Since 2016/8/2.
 */
public class AdminPromotionStatisticsDto implements Serializable {

	private static final long serialVersionUID = -8423369730818820724L;
	@Getter
	@Setter
	private Integer id;// 活动ID
	@Getter
	@Setter
	private String shortName;// 简称
	@Getter
	@Setter
	private Integer promType;// 活动类型 10 折扣 20 满减 30 秒杀 40 团购 50 荷兰拍
	@Getter
	@Setter
	private java.util.Date beginDate;// 开始时间
	@Getter
	@Setter
	private java.util.Date endDate;// 结束时间
	@Getter
	@Setter
	private Integer createOperType;// 创建人类型
	@Getter
	@Setter
	private String selectCode;// 单品code
	@Getter
	@Setter
	private String selectName;// 选品名称
	@Getter
	@Setter
	private Integer checkStatus;// 活动状态 只有已结束
	@Setter
	@Getter
	private Integer saleCount;// 活动销量
	@Setter
	@Getter
	private Integer stock;//库存
	@Setter
	@Getter
		private String goodsCode;//商品code

}
