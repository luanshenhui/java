package cn.com.cgbchina.promotion.dto;

import cn.com.cgbchina.promotion.model.PromotionModel;
import lombok.Getter;
import lombok.Setter;

/**
 * @author wenjia.hao
 * @version 1.0
 * @Since 2016/6/17.
 */
public class DoubleCheckStatusDto extends PromotionModel {
	@Setter
	@Getter
	private Integer doubleCheckStatus;
	@Setter
	@Getter
	private String doubleCheckStatusName;

}
