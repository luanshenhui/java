package cn.com.cgbchina.item.dto;

import java.io.Serializable;
import java.util.List;

import cn.com.cgbchina.item.model.PromotionModel;
import cn.com.cgbchina.item.model.PromotionRangeModel;
import lombok.Getter;
import lombok.Setter;

/**
 * 单品CODE查询返回用DTO
 *
 * @author wangqi
 * @version 1.0
 * @Since 2016/6/13.
 */
public class MallPromotionForItemResultDto extends PromotionModel implements Serializable {

	private static final long serialVersionUID = 2781082178466313570L;
	@Setter
	@Getter
	private String beginFormatDate;// 活动开始时间(yyyy/MM/dd HH:mm:ss)
	@Setter
	@Getter
	private String endFormatDate;// 活动开始时间(yyyy/MM/dd HH:mm:ss)
	@Setter
	@Getter
	private String promTypeName;// 活动类型名称
	@Setter
	@Getter
	private String ruleDiscountRateFormat;// 折扣比例(精确到小数点后一位)
	@Setter
	@Getter
	private String itemCode;// 单品CODE
	@Setter
	@Getter
	private List<PromotionRangeModel> promRangeList;// 活动范围（选品列表）
}
