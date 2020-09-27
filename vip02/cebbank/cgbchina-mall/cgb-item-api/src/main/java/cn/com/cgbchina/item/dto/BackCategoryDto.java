package cn.com.cgbchina.item.dto;

import cn.com.cgbchina.item.model.BackCategory;
import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;
import java.util.List;

/**
 * Created by 郝文佳 on 2016/4/29.
 */
public class BackCategoryDto extends BackCategory implements Serializable{

	private static final long serialVersionUID = -7768394266921185285L;
	@Setter
	@Getter
	private List<AttributeTransDto> attributeTransDtos;

	@Setter
	@Getter
	private List<BackCategory> backCategories;
}
