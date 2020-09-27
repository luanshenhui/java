package cn.com.cgbchina.user.model;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

public class MessageTemplateModel implements Serializable {

	private static final long serialVersionUID = -2843777221399323608L;
	@Getter
	@Setter
	private Long id;// 模板id
	@Getter
	@Setter
	private String name;// 模板名称
	@Getter
	@Setter
	private String type;// 模板类型
	@Getter
	@Setter
	private String memo;// 备注说明
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
	@Getter
	@Setter
	private String delFlag;// 逻辑删除标记0未删除1已删除
	@Getter
	@Setter
	private String url;// 模板文件所在路径
	@Getter
	@Setter
	private String statusType;// 状态类型
}