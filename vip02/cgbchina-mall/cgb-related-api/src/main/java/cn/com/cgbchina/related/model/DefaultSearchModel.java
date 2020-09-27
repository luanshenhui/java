package cn.com.cgbchina.related.model;

import lombok.Getter;
import lombok.Setter;
import java.io.Serializable;

public class DefaultSearchModel implements Serializable {

	private static final long serialVersionUID = -600526890059323172L;
	@Getter
	@Setter
	private Long id;//
	@Getter
	@Setter
	private String name;// 默认名字
	@Getter
	@Setter
	private String status;// 状态 0：开启 1：关闭
	@Getter
	@Setter
	private String delFlag;// 逻辑删除标记 0：未删除 1：已删除
	@Getter
	@Setter
	private String createOper;// 创建人
	@Getter
	@Setter
	private java.util.Date createTime;// 创建时间
	@Getter
	@Setter
	private String modifyOper;// 更新人
	@Getter
	@Setter
	private java.util.Date modifyTime;// 更新时间
}