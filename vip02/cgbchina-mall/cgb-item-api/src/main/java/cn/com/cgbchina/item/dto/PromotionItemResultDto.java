package cn.com.cgbchina.item.dto;

import cn.com.cgbchina.item.model.PromotionRangeModel;
import com.spirit.category.model.RichAttribute;
import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;
import java.util.List;

/**
 * 秒杀获取场次选品信息DTO
 *
 * @author huangfuchangyu
 * @version 1.0
 * @Since 2016/7/20
 */
public class PromotionItemResultDto extends PromotionRangeModel implements Serializable {
	private static final long serialVersionUID = 2781082178466313570L;
	@Setter
	@Getter
	private String installmentNumber;
	@Getter
	@Setter
	private String image1;// 图片1
	@Getter
	@Setter
	private String nowDate; // 当前时间
	@Getter
	@Setter
	private String startDate;// 开拍时间
	@Setter
	@Getter
	private String periodId;// 场次ID
	@Setter
	@Getter
	private Integer buyCount;// 销量
	@Getter
	@Setter
	private List<AuctionRecordDto> auctionList;// 拍卖纪录
	@Setter
	@Getter
	private java.math.BigDecimal perStage;//每期
	@Setter
	@Getter
	private List<RichAttribute> spuAttributes;//产品属性
	@Getter
	@Setter
	protected String attributeKey1;
	@Getter
	@Setter
	protected String attributeName1;
	@Getter
	@Setter
	protected String attributeValue1;
	@Getter
	@Setter
	protected String attributeKey2;
	@Getter
	@Setter
	protected String attributeName2;
	@Getter
	@Setter
	protected String attributeValue2;
	@Setter
	@Getter
	private String introduction;// 商品描述

	@Setter
	@Getter
	private java.math.BigDecimal nowPrice;//荷兰拍传递数据自用字段
}
