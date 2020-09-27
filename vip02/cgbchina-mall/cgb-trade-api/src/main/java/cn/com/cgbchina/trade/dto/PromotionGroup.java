package cn.com.cgbchina.trade.dto;

import java.io.Serializable;
import java.util.List;

import lombok.Getter;
import lombok.Setter;

/**
 * Created by
 */
public class PromotionGroup implements Serializable {

	private static final long serialVersionUID = 3633430791073102960L;

	@Getter
	@Setter
	private Integer promotionId;// 活动ID

	@Setter
	@Getter
	private String periodId;// 场次ID

	@Getter
	@Setter
	private Integer promType;// 活动类型 10 折扣 20 满减 30 秒杀 40 团购 50 荷兰拍

	@Getter
	@Setter
	private RuleFeeInfoDto ruleFeeInfo;	//减满规则(活动)

	@Getter
	@Setter
	private List<CartItemDto> cartItemDtoList;//	购物车单品信息


}
