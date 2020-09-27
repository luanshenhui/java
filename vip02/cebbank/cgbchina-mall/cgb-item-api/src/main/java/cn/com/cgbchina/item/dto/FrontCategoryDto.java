package cn.com.cgbchina.item.dto;

import cn.com.cgbchina.item.model.FrontCategory;
import com.google.common.base.MoreObjects;
import com.google.common.base.Objects;
import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;
import java.util.List;

/**
 * Created by 郝文佳 on 2016/5/12.
 */
public class FrontCategoryDto implements Serializable {

	private static final long serialVersionUID = 5076503266285703100L;
	@Setter
	@Getter
	private List<FrontCategory> frontCategories;// 当前类目的所有子节点
	@Getter
	@Setter
	private List<CategoryMappingDto> categoryMappingDtos;// 当前类目挂载的所有后台类目属性

	@Override
	public boolean equals(Object o) {
		if (this == o)
			return true;
		if (o == null || getClass() != o.getClass())
			return false;

		FrontCategoryDto that = (FrontCategoryDto) o;

		return Objects.equal(this.frontCategories, that.frontCategories)
				&& Objects.equal(this.categoryMappingDtos, that.categoryMappingDtos);
	}

	@Override
	public int hashCode() {
		return Objects.hashCode(frontCategories, categoryMappingDtos);
	}

	@Override
	public String toString() {
		return MoreObjects.toStringHelper(this).add("frontCategories", frontCategories)
				.add("categoryMappingDtos", categoryMappingDtos).toString();
	}
}
