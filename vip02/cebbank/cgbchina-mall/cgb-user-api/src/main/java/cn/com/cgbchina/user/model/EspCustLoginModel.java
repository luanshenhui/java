package cn.com.cgbchina.user.model;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

public class EspCustLoginModel implements Serializable {

	private static final long serialVersionUID = -8907832325931677452L;
	@Getter
	@Setter
	private Long id;//
	@Getter
	@Setter
	private String loginRandom;// 随机数
	@Getter
	@Setter
	private Long custId;// 客户id
	@Getter
	@Setter
	private java.util.Date createTime;// 登录时间
	@Getter
	@Setter
	private String loginFlag;// 登录状态0登录失败1登录成功
	@Getter
	@Setter
	private String loginIp;// 登录ip
	@Getter
	@Setter
	private String loginMac;// 登录mac地址
	@Getter
	@Setter
	private java.util.Date modifyTime;// 修改时间
	@Getter
	@Setter
	private String loginId;// 登录id
	@Getter
	@Setter
	private String reserved1;// 预留字段
	@Getter
	@Setter
	private String serverIp;// ip
}