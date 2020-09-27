package cn.com.cgbchina.item.dto;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;
import java.util.List;

/**
 * Created by Tanliang on 16-4-30.
 */
public class ItemsAttributeDto implements Serializable {

	private static final long serialVersionUID = 423097690192570207L;
	@Getter
	@Setter
	List<ItemAttributeDto> attributes;

	@Getter
	@Setter
	List<ItemsAttributeSkuDto> skus;
}
