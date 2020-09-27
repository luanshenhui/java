package cn.com.cgbchina.item.model;

import com.google.common.base.Objects;
import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

/**
 * 前台类目 Created by shixing on 16-4-26.
 */
public class FrontCategory extends BaseCategory implements Serializable {
	private static final long serialVersionUID = 2868436246470992603L;
	@Setter
	@Getter
	private Boolean isParent;

	@Override
	public boolean equals(Object o) {
		if (this == o)
			return true;
		if (o == null || getClass() != o.getClass())
			return false;

		FrontCategory that = (FrontCategory) o;

		return Objects.equal(this.isParent, that.isParent) && Objects.equal(this.id, that.id)
				&& Objects.equal(this.name, that.name) && Objects.equal(this.parentId, that.parentId);
	}

	@Override
	public int hashCode() {
		return Objects.hashCode(isParent, id, name, parentId);
	}
}
