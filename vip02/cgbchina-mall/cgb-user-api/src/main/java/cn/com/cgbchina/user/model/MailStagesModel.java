package cn.com.cgbchina.user.model;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

public class MailStagesModel implements Serializable {

	private static final long serialVersionUID = 7506404695586806024L;
	@Getter
	@Setter
	private Long id;//
	@Getter
	@Setter
	private String code;// 邮购分期类别码
	@Getter
	@Setter
	private String name;// 邮购分期类别名称
	@Getter
	@Setter
	private String vendorId;// 供应商id
	@Getter
	@Setter
	private Integer delFlag;// 逻辑删除标示0未删除1已删除
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