package cn.com.cgbchina.item.dto;

import com.google.common.base.MoreObjects;
import com.google.common.base.Objects;
import lombok.Getter;
import lombok.Setter;

import javax.validation.constraints.NotNull;
import java.io.Serializable;

/**
 * Created by 郝文佳 on 2016/5/11.
 */
public class CategoryMappingDto implements Serializable {

	private static final long serialVersionUID = 3761769387082831632L;
	@Setter
	@Getter
	@NotNull
	private Long frontCategoryId;
	@Setter
	@Getter
	@NotNull
	private Long backCategoryId;
	@Setter
	@Getter
	@NotNull
	private String path;

	@Override
	public boolean equals(Object o) {
		if (this == o)
			return true;
		if (o == null || getClass() != o.getClass())
			return false;

		CategoryMappingDto that = (CategoryMappingDto) o;

		return Objects.equal(this.frontCategoryId, that.frontCategoryId)
				&& Objects.equal(this.backCategoryId, that.backCategoryId) && Objects.equal(this.path, that.path);
	}

	@Override
	public int hashCode() {
		return Objects.hashCode(frontCategoryId, backCategoryId, path);
	}

	@Override
	public String toString() {
		return MoreObjects.toStringHelper(this).add("frontCategoryId", frontCategoryId)
				.add("backCategoryId", backCategoryId).add("path", path).toString();
	}
}
