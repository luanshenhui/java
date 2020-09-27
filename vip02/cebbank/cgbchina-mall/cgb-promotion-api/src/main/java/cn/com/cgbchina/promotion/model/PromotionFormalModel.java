package cn.com.cgbchina.promotion.model;

import lombok.Getter;
import lombok.Setter;
import java.io.Serializable;

public class PromotionFormalModel implements Serializable {

	private static final long serialVersionUID = -345416859963408454L;
	@Getter
	@Setter
	private Integer id;// 自增主键
	@Getter
	@Setter
	private Integer promotionId;// 活动ID
	@Getter
	@Setter
	private java.util.Date beginDate;// 开始时间
	@Getter
	@Setter
	private java.util.Date endDate;// 结束时间
	@Getter
	@Setter
	private String vendorId;// 供应商ID
	@Getter
	@Setter
	private Long brandId;// 品牌ID
	@Getter
	@Setter
	private Long backCategoryId;// 后台类目ID
	@Getter
	@Setter
	private String goodsId;// 商品ID
	@Getter
	@Setter
	private String itemId;// 单品ID
	@Getter
	@Setter
	private String channelTypes;// 销售渠道（0 WEB商城，1 APP商城）格式：||01||02||
	@Getter
	@Setter
	private java.util.Date createDate;// 创建时间
	@Getter
	@Setter
	private Integer sales;// 销量

}