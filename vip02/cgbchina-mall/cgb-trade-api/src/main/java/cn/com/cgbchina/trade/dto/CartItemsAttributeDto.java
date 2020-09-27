package cn.com.cgbchina.trade.dto;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;
import java.util.List;

/**
 * Created by Tanliang on 16-4-30.
 */
public class CartItemsAttributeDto implements Serializable {
	private static final long serialVersionUID = 8344404305130822608L;
	@Getter
	@Setter
	List<CartItemAttributeDto> attributes;

	@Getter
	@Setter
	List<CartItemsAttributeSkuDto> skus;
}
