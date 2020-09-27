package cn.com.cgbchina.item.dto;

import com.google.common.base.MoreObjects;
import com.google.common.base.Objects;
import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

/**
 * Created by 郝文佳 on 2016/4/29.
 */
public class AttributeTransDto implements Serializable {

	private static final long serialVersionUID = -7189850125748805815L;
	@Getter
	@Setter
	private Long id;

	@Getter
	@Setter
	private String name;

	@Getter
	@Setter
	private Integer type;// 1 attributeKey产品属性 2 销售属性 spu

	@Getter
	@Setter
	private Boolean isInherit;// 是否继承与父类目

	@Override
	public boolean equals(Object o) {
		if (this == o)
			return true;
		if (o == null || getClass() != o.getClass())
			return false;

		AttributeTransDto that = (AttributeTransDto) o;

		return Objects.equal(this.id, that.id) && Objects.equal(this.name, that.name)
				&& Objects.equal(this.type, that.type) && Objects.equal(this.isInherit, that.isInherit);
	}

	@Override
	public int hashCode() {
		return Objects.hashCode(id, name, type, isInherit);
	}

	@Override
	public String toString() {
		return MoreObjects.toStringHelper(this).add("id", id).add("name", name).add("type", type)
				.add("isInherit", isInherit).toString();
	}
}
