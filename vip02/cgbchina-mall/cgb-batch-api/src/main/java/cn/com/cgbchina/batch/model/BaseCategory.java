package cn.com.cgbchina.batch.model;

import lombok.Getter;
import lombok.Setter;

import javax.validation.constraints.NotNull;
import java.io.Serializable;

/**
 * Created by shixing on 16-4-26.
 */
public abstract class BaseCategory implements Serializable {

	private static final long serialVersionUID = 6353771339325827794L;
	@Getter
	@Setter
	protected Long id;

	@Getter
	@Setter
	@NotNull(message = "类目名称不能为空")
	protected String name;

	@Getter
	@Setter
	@NotNull(message = "parentId不能为空")
	protected Long parentId;
}
