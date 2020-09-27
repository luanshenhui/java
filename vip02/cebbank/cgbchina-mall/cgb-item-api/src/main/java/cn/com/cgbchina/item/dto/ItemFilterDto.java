package cn.com.cgbchina.item.dto;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;
import java.util.List;

/**
 * Created by 133625 on 16-5-13.
 */
public class ItemFilterDto implements Serializable {


	private static final long serialVersionUID = -6950422483179548326L;
	@Setter
	@Getter
	private String id;

	@Setter
	@Getter
	private String name;

	@Setter
	@Getter
	private String spell;

	@Setter
	@Getter
	private Long count;

	@Setter
	@Getter
	private List<ItemFilterDto> ItemFilterDtoList;
}
