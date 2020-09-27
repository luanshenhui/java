package cn.com.cgbchina.item.dto;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.List;

/**
 * Created by 133625 on 16-5-13.
 */
public class ItemSearchResultDto implements Serializable {

	private static final long serialVersionUID = -4215867515334848265L;
	@Setter
	@Getter
	private String itemCode;

	@Setter
	@Getter
	private String goodsName;

	@Setter
	@Getter
	private String price;

	@Setter
	@Getter
	private List<ItemAttributeDto> itemAttributeDtoList;

	@Setter
	@Getter
	private String image1;

	@Setter
	@Getter
	private String favoriteType;
}
