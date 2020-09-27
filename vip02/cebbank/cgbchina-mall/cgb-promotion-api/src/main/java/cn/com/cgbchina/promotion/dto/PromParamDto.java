package cn.com.cgbchina.promotion.dto;

import cn.com.cgbchina.promotion.model.PromotionModel;
import cn.com.cgbchina.promotion.model.PromotionRangeModel;
import cn.com.cgbchina.promotion.model.PromotionVendorModel;
import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;
import java.util.List;

/**
 * 活动范围
 *
 * @author wangqi
 * @version 1.0
 * @Since 2016/6/13.
 */
public class PromParamDto implements Serializable {

	private static final long serialVersionUID = 2781082178466313570L;

	@Setter
	@Getter
	private List<PromotionRangeModel> promotionRangeModelList;
	@Setter
	@Getter
	private PromotionModel promotionModel;
	@Setter
	@Getter
	private PromotionVendorModel promotionVendorModel;
	@Setter
	@Getter
	private String id;
	@Setter
	@Getter
	private String strPromotionRangeModel;
}
