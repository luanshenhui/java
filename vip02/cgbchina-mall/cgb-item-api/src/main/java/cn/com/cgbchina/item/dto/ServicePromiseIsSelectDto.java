package cn.com.cgbchina.item.dto;

import cn.com.cgbchina.common.contants.Contants;
import com.google.common.base.MoreObjects;
import com.google.common.base.Objects;
import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

/**
 * Created by 陈乐 on 2016/4/27.
 */
public class ServicePromiseIsSelectDto implements Serializable {

	private static final long serialVersionUID = -673111153748971042L;
	@Getter
	@Setter
	private Integer code;//服务承诺ID
	@Getter
	@Setter
	private String name;// 名称
	@Getter
	@Setter
	private Boolean isSelected = Boolean.FALSE;// 是否被选中 默认未选中

	@Override
	public boolean equals(Object o) {
		if (this == o)
			return true;
		if (o == null || getClass() != o.getClass())
			return false;

		ServicePromiseIsSelectDto that = (ServicePromiseIsSelectDto) o;

		return Objects.equal(this.code, that.code) && Objects.equal(this.name, that.name)
				&& Objects.equal(this.isSelected, that.isSelected);
	}

	@Override
	public int hashCode() {
		return Objects.hashCode(code, name, isSelected);
	}

	@Override
	public String toString() {
		return MoreObjects.toStringHelper(this).add("code", code).add("name", name).add("isSelected", isSelected)
				.toString();
	}
}
