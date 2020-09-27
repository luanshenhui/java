package cn.com.cgbchina.item.dto;

import cn.com.cgbchina.item.model.BaseCategory;
import com.google.common.base.Objects;
import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

/**
 * Created by 郝文佳 on 2016/5/16.
 */
public class FrontCategoryMappingDto extends BaseCategory  implements Serializable{

	private static final long serialVersionUID = 8863368831226085040L;
	@Setter
	@Getter
	private Integer level;

	@Override
	public String toString() {
		return Objects.toStringHelper(this).add("level", level).add("id", id).add("name", name)
				.add("parentId", parentId).toString();
	}

	@Override
	public boolean equals(Object o) {
		if (this == o)
			return true;
		if (o == null || getClass() != o.getClass())
			return false;

		FrontCategoryMappingDto that = (FrontCategoryMappingDto) o;

		return Objects.equal(this.level, that.level) && Objects.equal(this.id, that.id)
				&& Objects.equal(this.name, that.name) && Objects.equal(this.parentId, that.parentId);
	}

	@Override
	public int hashCode() {
		return Objects.hashCode(level, id, name, parentId);
	}
}
