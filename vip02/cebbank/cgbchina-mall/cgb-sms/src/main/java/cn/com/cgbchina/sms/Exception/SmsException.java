/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.sms.Exception;

/**
 * @author 11140721050130
 * @version 1.0
 * @created at 2016/6/14.
 */
public class SmsException extends RuntimeException {
	public SmsException() {
	}

	public SmsException(String s) {
		super(s);
	}

	public SmsException(String s, Throwable throwable) {
		super(s, throwable);
	}

	public SmsException(Throwable throwable) {
		super(throwable);
	}
}
