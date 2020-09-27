package cn.com.cgbchina.trade.dto;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;
import java.util.List;

/**
 * Created by Congzy
 */
public class CartGfShopDto implements Serializable {
	//	广发商城返回数据
	private static final long serialVersionUID = 8167422244824186614L;

	@Getter
	@Setter
	CreditCardCartItemDto creditCard;

	@Getter
	@Setter
	List<CartItemDto> bankCardList;
}
