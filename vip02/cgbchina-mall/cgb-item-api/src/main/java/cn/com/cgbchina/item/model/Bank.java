package cn.com.cgbchina.item.model;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

public class Bank implements Serializable {


	private static final long serialVersionUID = -1435522572420135821L;
	@Getter
	@Setter
	private Long id;//
	@Getter
	@Setter
	private String code;// 分行号
	@Getter
	@Setter
	private String name;// 分行名称
	@Getter
	@Setter
	private Long cityId;// 发卡城市id
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