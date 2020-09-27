package cn.com.cgbchina.item.model;

import com.google.common.base.MoreObjects;
import com.google.common.base.Objects;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.validator.constraints.Length;

import javax.validation.constraints.NotNull;
import javax.validation.constraints.Pattern;
import java.io.Serializable;

/**
 * Created by 11150221040129 on 16-4-8.
 */
public class AttributeKey implements Serializable {

	private static final long serialVersionUID = -3391064358777869746L;
	@Getter
	@Setter
	private Long id; // 主键 10000
	@Getter
	@Setter
	@NotNull(message = "{attributeKey.name.notNull}")
	@Pattern(regexp = "^[A-Za-z0-9\\u4e00-\\u9fa5]+$", message = "attribute.pattern")
	@Length(max = 20)
	private String name;// 名称 颜色
	@Getter
	@Setter
	private Long count;// 计数器 用于判断当前是否有类目挂钩

	@Override
	public boolean equals(Object o) {
		if (this == o)
			return true;
		if (o == null || getClass() != o.getClass())
			return false;

		AttributeKey that = (AttributeKey) o;

		return Objects.equal(this.id, that.id) && Objects.equal(this.name, that.name);
	}

	@Override
	public int hashCode() {
		return Objects.hashCode(id, name);
	}

	@Override
	public String toString() {
		return MoreObjects.toStringHelper(this).add("id", id).add("name", name).toString();
	}
}
