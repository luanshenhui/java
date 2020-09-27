package cn.com.cgbchina.user.model;

/**
 * Created by 11140721050130 on 2016/4/27.
 */
public enum LoginType{


	BUYER(1), // 买家
	VENDOR(2), // 供应商
	ADMIN(3);// 管理平台

	private final int value;

	private LoginType(int value) {
		this.value = value;
	}

	public static LoginType from(int value) {
		for (LoginType loginType : LoginType.values()) {
			if (loginType.value == value) {
				return loginType;
			}
		}
		return null;
	}
}
