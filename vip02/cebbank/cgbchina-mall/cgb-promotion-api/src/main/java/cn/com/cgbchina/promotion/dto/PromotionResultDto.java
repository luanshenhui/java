package cn.com.cgbchina.promotion.dto;

import cn.com.cgbchina.promotion.model.PromotionModel;
import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.List;

/**
 * 活动详情用DTO
 *
 * @author wangqi
 * @version 1.0
 * @Since 2016/6/13.
 */
public class PromotionResultDto extends PromotionModel implements Serializable {

	private static final long serialVersionUID = 2781082178466313570L;
	@Setter
	@Getter
	private String beginFormatDate;// 活动开始时间(yyyy/MM/dd HH:mm:ss)
	@Setter
	@Getter
	private String endFormatDate;// 活动开始时间(yyyy/MM/dd HH:mm:ss)
	@Setter
	@Getter
	private String beginEntryFormatDate;// 报名开始时间(yyyy/MM/dd HH:mm:ss)
	@Setter
	@Getter
	private String endEntryFormatDate;// 报名开始时间(yyyy/MM/dd HH:mm:ss)
	@Setter
	@Getter
	private String promTypeName;// 活动类型名称
	@Setter
	@Getter
	private String loopJobFormat;// 循环执行
	@Setter
	@Getter
	private String ruleDiscountRateFormat;// 折扣比例(精确到小数点后一位)
	@Setter
	@Getter
	private String sourceName;// 销售渠道名称
	@Setter
	@Getter
	private String createOperTypeName;// 发起者类型
	@Setter
	@Getter
	private List<PromItemDto> promItemList;// 活动范围
	@Setter
	@Getter
	private Boolean promAvailable;// 活动当前供应商是否可以报名
}
