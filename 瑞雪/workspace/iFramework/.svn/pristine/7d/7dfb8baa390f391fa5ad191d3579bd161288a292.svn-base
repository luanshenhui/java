package com.dhc.base.audit;

public enum SysActionType implements IActionType {
	LOGIN("login", "登录"), LOGOUT("logout", "登出");

	private String desc; // 枚举说明
	private String code; // 枚举代码

	private SysActionType(String code, String desc) {
		this.desc = desc;
		this.code = code;
	}

	/**
	 * 获取枚举值的说明
	 * 
	 * @return String
	 */
	public String getDesc() {
		return desc;
	}

	/**
	 * 获取枚举值的代码
	 * 
	 * @return String
	 */
	public String getCode() {
		return code;
	}

	private static int number = SysActionType.values().length;

	public static void main(String args[]) {
		for (SysActionType enumSS : SysActionType.values()) {
			System.out.println(enumSS + " " + enumSS.getCode() + " " + enumSS.getDesc());
		}
	}
}
