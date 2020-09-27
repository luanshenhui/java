package cn.com.cgbchina.item.dto;

import com.google.common.base.Objects;
import lombok.Getter;
import lombok.Setter;

import javax.validation.constraints.NotNull;
import java.io.Serializable;

/**
 * Created by 郝文佳 on 2016/5/16.
 */
public class FrontCategoryEditDto implements Serializable {

	private static final long serialVersionUID = 3105444571147743244L;
	@Setter
	@Getter
	@NotNull
	private Long id; // 前台类目id
	@Setter
	@Getter
	@NotNull
	private String newName;// 前台类目要更改的名字

	@Override
	public boolean equals(Object o) {
		if (this == o)
			return true;
		if (o == null || getClass() != o.getClass())
			return false;

		FrontCategoryEditDto that = (FrontCategoryEditDto) o;

		return Objects.equal(this.id, that.id) && Objects.equal(this.newName, that.newName);
	}

	@Override
	public int hashCode() {
		return Objects.hashCode(id, newName);
	}

}
