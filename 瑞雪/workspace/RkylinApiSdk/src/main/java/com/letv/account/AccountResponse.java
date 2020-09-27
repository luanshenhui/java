package com.letv.account;

import com.letv.common.Responseheader;

/**
 * 用于接收查询渠道乐视用户请求后返回响应结果的类
 *
 */
public class AccountResponse {

	//响应结果中的head
	public Responseheader header = new Responseheader();
	//响应结果中的body
	public AccountResponseBody body = new AccountResponseBody();

}
