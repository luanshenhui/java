package cn.com.cgbchina.user.model;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

public class ShopMemberModel implements Serializable {

	private static final long serialVersionUID = -562059344073134350L;
	@Getter
	@Setter
	private Long id;//
	@Getter
	@Setter
	private String userCode;// 客户登录名
	@Getter
	@Setter
	private String cardCode;// 卡号
	@Getter
	@Setter
	private String custIdNbr;// 证件号码
	@Getter
	@Setter
	private String custIdType;// 证件类别
	@Getter
	@Setter
	private String password;// 登录密码
	@Getter
	@Setter
	private Integer pwStrength;// 密码强度
	@Getter
	@Setter
	private java.util.Date regTime;// 注册时间
	@Getter
	@Setter
	private String showName;// 昵称
	@Getter
	@Setter
	private String isUserCodeAuth;// 是否用户名认证(0是1否)
	@Getter
	@Setter
	private String isCardCodeAuth;// 是否卡号认证(0是1否)
	@Getter
	@Setter
	private String isMobileAuth;// 是否手机认证(0是1否)
	@Getter
	@Setter
	private Integer userGrade;// 会员等级
	@Getter
	@Setter
	private java.util.Date lastLoginTime;// 最后登录时间
	@Getter
	@Setter
	private String delFlag;// 逻辑删除标记0未删除1已删除
}