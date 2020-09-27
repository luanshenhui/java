package cn.com.cgbchina.user.model;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

public class AdminRoleModel implements Serializable {

	private static final long serialVersionUID = -1581492300398710519L;
	@Getter
	@Setter
	private Long id;// 角色ID 自增
	@Getter
	@Setter
	private Long pid;// 角色父ID
	@Getter
	@Setter
	private String name;// 角色名称
	@Getter
	@Setter
	private String type;// 角色类型
	@Getter
	@Setter
	private String descript;// 角色描述
	@Getter
	@Setter
	private String checkStatus;// 审核状态 0:否 1:是(新增) 2:是(修改) 3:是(删除) 4:同意 5:拒绝
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
	@Getter
	@Setter
	private String isEnabled;// 是否启用(0是1否)
}