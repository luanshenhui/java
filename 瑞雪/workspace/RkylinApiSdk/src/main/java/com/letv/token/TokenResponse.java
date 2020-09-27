package com.letv.token;
import com.letv.common.Responseheader;
import com.letv.token.TokenResponseBody;

/**
 * 用于接收Token请求后返回响应结果的类
 */
public class TokenResponse
{
	//响应结果中的head
	public Responseheader header = new Responseheader();
	//响应结果中的body
	public TokenResponseBody body = new TokenResponseBody();
}


