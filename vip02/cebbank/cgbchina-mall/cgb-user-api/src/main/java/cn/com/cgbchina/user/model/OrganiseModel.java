package cn.com.cgbchina.user.model;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

public class OrganiseModel implements Serializable {

	private static final long serialVersionUID = 7372755756364454897L;
	@Getter
	@Setter
	private String code;// 机构代码
	@Getter
	@Setter
	private String fullName;// 机构名称
	@Getter
	@Setter
	private String simpleName;// 机构简称
	@Getter
	@Setter
	private String level;// 级别
	@Getter
	@Setter
	private String descript;// 描述
	@Getter
	@Setter
	private String status;// 状态
	@Getter
	@Setter
	private String checkStatus;// 审核状态0否1新增2修改3删除4同意5拒绝
	@Getter
	@Setter
	private String refuseDesc;// 拒绝原因
	@Getter
	@Setter
	private String createOper;// 创建人
	@Getter
	@Setter
	private String modifyOper;// 修改人
	@Getter
	@Setter
	private java.util.Date createTime;// 创建时间
	@Getter
	@Setter
	private java.util.Date modifyTime;// 修改时间
	@Getter
	@Setter
	private String delFlag;// 逻辑删除标记0未删除1已删除
}