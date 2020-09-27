package cn.com.cgbchina.rest.common.util;

/**
 * Created by 1115012105001 on 2016/12/20.
 */
public class ConnectionLimitException extends RuntimeException {
	public ConnectionLimitException() {
		super("连接数已达上限");
	}
}
