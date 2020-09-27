package cn.com.cgbchina.item.dto;

import cn.com.cgbchina.item.model.PromotionModel;
import lombok.Getter;
import lombok.Setter;

/**
 * @author wenjia.hao
 * @version 1.0
 * @Since 2016/6/17.
 */
public class DoubleCheckStatusDto extends PromotionModel {
	private static final long serialVersionUID = -1098116307794956900L;
	@Setter
	@Getter
	private Integer doubleCheckStatus;
	@Setter
	@Getter
	private String doubleCheckStatusName;

}
