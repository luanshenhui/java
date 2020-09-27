package cn.com.cgbchina.user.model;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

public class EspCustNewModel implements Serializable {

	private static final long serialVersionUID = 9216334737525737893L;
	@Getter
	@Setter
	private String custId;// 客户号
	@Getter
	@Setter
	private String loginIp;// 登陆ip
	@Getter
	@Setter
	private String birthUsedYear;// 客户生日年份
	@Getter
	@Setter
	private Integer birthUsedCount;// 客户该年份使用生日次数
	@Getter
	@Setter
	private java.util.Date lastLoginTime;// 最后登陆时间
	@Getter
	@Setter
	private String sessionId;// session id
	@Getter
	@Setter
	private String loginMac;// mac
}