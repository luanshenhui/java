package cn.com.cgbchina.trade.dto;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;
import java.util.List;

/**
 * Created by Tanliang on 16-4-30.
 */
public class CartItemsAttributeSkuDto implements Serializable {
	private static final long serialVersionUID = -7922722056238426991L;
	@Getter
	@Setter
	private Long attributeValueKey;// 属性key

	@Getter
	@Setter
	private String attributeValueName;// 属性名称

	@Getter
	@Setter
	List<CartItemAttributeDto> values;
}
