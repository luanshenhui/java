package cn.com.cgbchina.trade.dto;

import java.io.Serializable;
import java.util.List;

import lombok.Getter;
import lombok.Setter;

/**
 * Created by
 */
public class CreditCardCartItemDto implements Serializable {


	private static final long serialVersionUID = 7186482709941763166L;

	@Getter
	@Setter
	List<PromotionGroup> promotionList;

	@Getter
	@Setter
	List<CartItemDto> ordinaryList;
}
