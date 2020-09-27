package cn.com.cgbchina.related.model;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

public class LocalProcodeModel implements Serializable {

	@Getter
	@Setter
	private Long id;// 自增主键
	@Getter
	@Setter
	private String proCode;// 白金卡等级编码
	@Getter
	@Setter
	private String proNm;// 白金卡等级名称
	@Getter
	@Setter
	private Integer delFlag;// 逻辑删除标记 0：未删除 1：已删除
	@Getter
	@Setter
	private String createOper;// 创建人
	@Getter
	@Setter
	private java.util.Date createTime;// 创建时间
	@Getter
	@Setter
	private String modifyOper;// 修改人
	@Getter
	@Setter
	private java.util.Date modifyTime;// 修改时间
}