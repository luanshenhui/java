package cn.com.cgbchina.item.dto;

import cn.com.cgbchina.item.dto.ItemAttributeDto;
import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;
import java.util.List;

/**
 * Created by Tanliang on 16-4-30.
 */
public class ItemsAttributeSkuDto implements Serializable{

	private static final long serialVersionUID = 5039158585385644851L;
	@Getter
	@Setter
	private Long attributeValueKey;// 属性key

	@Getter
	@Setter
	private String attributeValueName;// 属性名称

	@Getter
	@Setter
	List<ItemAttributeDto> values;
}
