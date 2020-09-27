package com.dpn.ciqqlc.webservice.io;

import java.io.Serializable;

public class BaseIo implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1562439951811425989L;

	/**
	 * 用户名
	 */
	private String userName;
	
	/**
	 * 密码 eg:xxxx_ciqs
	 */
	private String passWord;

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public String getPassWord() {
		return passWord;
	}

	public void setPassWord(String passWord) {
		this.passWord = passWord;
	}
	
}
