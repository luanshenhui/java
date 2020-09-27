package cn.com.cgbchina.user.model;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.spirit.user.User;
import lombok.Getter;
import lombok.Setter;

import javax.validation.constraints.NotNull;
import java.io.Serializable;

public class UserInfoModel extends User implements Serializable {

	private static final long serialVersionUID = 8037333407422813443L;
	@Getter
	@Setter
	@NotNull
	private String userId;// 账户id
	@Getter
	@Setter
	@NotNull
	private String orgCode;// 组织代码
	@Getter
	@Setter
	private String pwfirst;// 一次密码
	@Getter
	@Setter
	@JsonIgnore
	private String pwsecond;// 二次密码
	@Getter
	@Setter
	@JsonIgnore
	private String password;// 密码
	@Getter
	@Setter
	private String papersType;// 用户证件
	@Getter
	@Setter
	private String papersNum;// 证件号码
	@Getter
	@Setter
	@NotNull
	private String phone;// 电话
	@Getter
	@Setter
	private String fax;// 传真
	@Getter
	@Setter
	private String email;//
	@Getter
	@Setter
	private String descript;// 用户描述
	@Getter
	@Setter
	@NotNull
	private String status;// 当前状态
	@Getter
	@Setter
	private String checkStatus;// 审核状态
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
	@JsonIgnore
	private java.util.Date createTime;// 创建时间
	@Getter
	@Setter
	@JsonIgnore
	private java.util.Date modifyTime;// 修改时间
//	@Getter
//	@Setter
	private String isFirst;// 密码状态是否第一次登陆0表示为初始值或重置值1用户修改后值
	@Getter
	@Setter
	@JsonIgnore
	private java.util.Date editPwTime;// 失效时间修改密码时间
	@Getter
	@Setter
	private java.util.Date loginTime;// 登录时间
	@Getter
	@Setter
	private Integer loginCount;// 登陆次数
	@Getter
	@Setter
	private Integer errorCount;// 错误登陆次数
	@Getter
	@Setter
	private String delFlag;// 逻辑删除标记0未删除1已删除

	public String getIsFirst() {
		return isFirst;
	}

	public void setIsFirst(String isFirst) {
		this.isFirst = isFirst;
	}
}