package cn.com.cgbchina.item.model;

import com.google.common.base.MoreObjects;
import com.google.common.base.Objects;
import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

/**
 * Created by 郝文佳 on 2016/4/21.
 */
public class AttributeValue implements Serializable {

	private static final long serialVersionUID = -7062555298062703228L;
	@Setter
	@Getter
	private Long id;
	@Setter
	@Getter
	private String value;

	@Override
	public String toString() {
		return MoreObjects.toStringHelper(this).add("id", id).add("value", value).toString();
	}

	@Override
	public boolean equals(Object o) {
		if (this == o)
			return true;
		if (o == null || getClass() != o.getClass())
			return false;

		AttributeValue that = (AttributeValue) o;

		return Objects.equal(this.id, that.id) && Objects.equal(this.value, that.value);
	}

	@Override
	public int hashCode() {
		return Objects.hashCode(id, value);
	}
}
