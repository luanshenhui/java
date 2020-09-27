package cn.com.cgbchina.item.model;

import lombok.Getter;
import lombok.Setter;
import java.io.Serializable;

public class ServicePromiseModel implements Serializable {

	private static final long serialVersionUID = 5197667655989416153L;
	@Getter
	@Setter
	private Integer code;// 服务承诺ID
	@Getter
	@Setter
	private String name;// 名称
	@Getter
	@Setter
	private Integer sort;// 显示顺序
	@Getter
	@Setter
	private String icon;// 图标
	@Getter
	@Setter
	private String isEnable;// 启用标志0已启用1未启用
	@Getter
	@Setter
	private Integer delFlag;// 逻辑删除标记 0：未删除 1：已删除
	@Getter
	@Setter
	private String createOper;// 创建者
	@Getter
	@Setter
	private java.util.Date createTime;// 创建时间
	@Getter
	@Setter
	private String modifyOper;// 修改者
	@Getter
	@Setter
	private java.util.Date modifyTime;// 修改时间
}