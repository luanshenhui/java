package com.letv.token;

/**
 * 用于接收Token请求后返回响应结果的Body类
 */
public class TokenResponseBody {
	
	//token
	private String token;
	//有效期（秒）
	private long expire_in;
	
	public long getExpire_in() {
		return expire_in;
	}
	public void setExpire_in(long expire_in) {
		this.expire_in = expire_in;
	}
	public String getToken() {
		return token;
	}
	public void setToken(String token) {
		this.token = token;
	}
}