package cn.com.cgbchina.trade.dto;

import com.google.common.base.Objects;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.io.Serializable;

/**
 * Created by 11141021040453 on 16-4-29.
 */
@NoArgsConstructor
@AllArgsConstructor
public class OrderItemAttributeDto implements Serializable {
	private static final long serialVersionUID = 4719012071014920872L;
	@Getter
	@Setter
	private Long attributeKey;// 属性key
	@Getter
	@Setter
	private String attributeName;// 属性名称
	@Getter
	@Setter
	private Long attributeValueKey;// 属性值key
	@Getter
	@Setter
	private String attributeValueName;// 属性值

	@Override
	public boolean equals(Object o) {
		if (this == o)
			return true;
		if (o == null || getClass() != o.getClass())
			return false;

		OrderItemAttributeDto that = (OrderItemAttributeDto) o;

		return Objects.equal(this.attributeKey, that.attributeKey)
				&& Objects.equal(this.attributeName, that.attributeName)
				&& Objects.equal(this.attributeValueKey, that.attributeValueKey)
				&& Objects.equal(this.attributeValueName, that.attributeValueName);
	}

	@Override
	public int hashCode() {
		return Objects.hashCode(attributeKey, attributeName, attributeValueKey, attributeValueName);
	}

	@Override
	public String toString() {
		return Objects.toStringHelper(this).add("attributeKey", attributeKey).add("attributeName", attributeName)
				.add("attributeValueKey", attributeValueKey).add("attributeValueName", attributeValueName).toString();
	}
}
