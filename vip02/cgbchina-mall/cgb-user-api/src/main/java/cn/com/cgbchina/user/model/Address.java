package cn.com.cgbchina.user.model;

import com.google.common.base.MoreObjects;
import com.google.common.base.Objects;
import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

public class Address implements Serializable {
	private static final long serialVersionUID = 1842929503746211283L;

	@Getter
	@Setter
	private Integer id;

	@Getter
	@Setter
	private Integer parentId;

	@Getter
	@Setter
	private String name;

	@Getter
	@Setter
	private Integer level;

	@Override
	public boolean equals(Object o) {
		if (o == null || !(o instanceof Address)) {
			return false;
		}
		Address that = (Address) o;
		return Objects.equal(id, that.id) && Objects.equal(parentId, that.parentId) && Objects.equal(name, that.name)
				&& Objects.equal(level, that.level);
	}

	@Override
	public String toString() {
		return MoreObjects.toStringHelper(this).add("id", id).add("parentId", parentId).add("name", name)
				.add("level", level).toString();
	}

	@Override
	public int hashCode() {
		return Objects.hashCode(this.id, this.parentId, this.name, this.level);
	}
}
