package cn.com.cgbchina.item.dto;

import com.google.common.base.MoreObjects;
import com.google.common.base.Objects;
import lombok.Getter;
import lombok.Setter;

import javax.validation.constraints.NotNull;
import java.io.Serializable;

/**
 * Created by 郝文佳 on 2016/5/10.
 */
public class BackCategoryEditDto implements Serializable {

	private static final long serialVersionUID = -5608127474237798080L;
	@Getter
	@Setter
	@NotNull
	private Long id;
	@Getter
	@Setter
	@NotNull
	private String oldName;
	@Getter
	@Setter
	@NotNull
	private String newName;

	@Override
	public boolean equals(Object o) {
		if (this == o)
			return true;
		if (o == null || getClass() != o.getClass())
			return false;

		BackCategoryEditDto that = (BackCategoryEditDto) o;

		return Objects.equal(this.id, that.id) && Objects.equal(this.oldName, that.oldName)
				&& Objects.equal(this.newName, that.newName);
	}

	@Override
	public int hashCode() {
		return Objects.hashCode(id, oldName, newName);
	}

	@Override
	public String toString() {
		return MoreObjects.toStringHelper(this).add("id", id).add("oldName", oldName).add("newName", newName)
				.toString();
	}
}
