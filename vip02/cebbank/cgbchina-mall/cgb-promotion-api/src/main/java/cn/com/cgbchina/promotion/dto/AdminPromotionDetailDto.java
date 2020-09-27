package cn.com.cgbchina.promotion.dto;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;
import java.util.List;

/**
 * @author wenjia.hao
 * @version 1.0
 * @Since 2016/6/20.
 */
public class AdminPromotionDetailDto implements Serializable {

	private static final long serialVersionUID = 8113822875567906592L;
	@Setter
	@Getter
	private AdminPromotionResultDto adminPromotionResultDto;
	@Getter
	@Setter
	private List<PromItemDto> promItemDtos;
	@Getter
	@Setter
	private List<VendorIdNameDto> vendorIdNameDtos;

}
