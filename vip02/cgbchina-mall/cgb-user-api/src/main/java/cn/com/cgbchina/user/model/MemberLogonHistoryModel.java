package cn.com.cgbchina.user.model;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

public class MemberLogonHistoryModel implements Serializable {

	private static final long serialVersionUID = -3943531673409220328L;
	@Getter
	@Setter
	private Long id;//
	@Getter
	@Setter
	private String custId;// 会员编号
	@Getter
	@Setter
	private String ipAddress;// ip
	@Getter
	@Setter
	private String macAddress;//
	@Getter
	@Setter
	private java.util.Date loginTime;// 登录时间
	@Getter
	@Setter
	private java.util.Date logoutTime;//
	@Getter
	@Setter
	private String status;// 登录状态0成功1失败
	@Getter
	@Setter
	private String delFlag;// 逻辑删除标记0未删除1已删除
}