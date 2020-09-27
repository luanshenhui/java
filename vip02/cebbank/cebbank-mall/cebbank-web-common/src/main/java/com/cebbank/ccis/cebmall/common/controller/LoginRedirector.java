package com.cebbank.ccis.cebmall.common.controller;

import com.spirit.user.User;

/**
 * Created by 11140721050130 on 2016/4/30.
 */
public interface LoginRedirector {

	/**
	 * 登录后跳转地址，若target不为空，则返回target地址
	 * 
	 * @param target 若target不为空，则返回target地址，
	 * @param user 用户
	 * @return 跳转地址
	 */
	public String redirectTarget(String target, User user);
}
