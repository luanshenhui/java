package cn.com.cgbchina.promotion.dto;

import cn.com.cgbchina.promotion.model.PromotionModel;
import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;
import java.util.List;

/**
 * @author wenjia.hao
 * @version 1.0
 * @Since 2016/6/22.
 */
public class AdminPromotionResultDto extends PromotionModel implements Serializable {

	private static final long serialVersionUID = 2240071052913446927L;
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
	private String createOperTypeName;// 发起者类型
	@Setter
	@Getter
	private String sourceNames;// 格式化数据 处理渠道编码
	@Setter
	@Getter
	private List<Integer> ruleMinPays;//满减中的满
	@Setter
	@Getter
	private List<Integer> ruleFees;//满减中的减
}
