package cn.com.cgbchina.item.dto;

import cn.com.cgbchina.item.model.AttributeKey;
import com.google.common.base.MoreObjects;
import com.google.common.base.Objects;
import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;
import java.util.List;

/**
 * Created by shixing on 16-4-27.
 */
public class AttributeDto implements Serializable {

	private static final long serialVersionUID = -864652771533068511L;
	@Getter
	@Setter
	private List<AttributeKey> attribute;

	@Getter
	@Setter
	private List<AttributeKey> sku;

	@Override
	public boolean equals(Object o) {
		if (this == o)
			return true;
		if (o == null || getClass() != o.getClass())
			return false;

		AttributeDto that = (AttributeDto) o;

		return Objects.equal(this.attribute, that.attribute) && Objects.equal(this.sku, that.sku);
	}

	@Override
	public int hashCode() {
		return Objects.hashCode(attribute, sku);
	}

	@Override
	public String toString() {
		return MoreObjects.toStringHelper(this).add("attribute", attribute).add("sku", sku).toString();
	}
}
