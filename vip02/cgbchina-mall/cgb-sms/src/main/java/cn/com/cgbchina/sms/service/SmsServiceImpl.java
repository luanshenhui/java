/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.sms.service;

import cn.com.cgbchina.sms.SmsService;

import javax.xml.ws.Response;

/**
 * @author 11140721050130
 * @version 1.0
 * @created at 2016/6/14.
 */
public class SmsServiceImpl implements SmsService {
	@Override
	public Response<Boolean> sendSingle(String from, String to, String message) {
		return null;
	}

	@Override
	public Response<Boolean> sendGroup(String from, Iterable<String> to, String message) {
		return null;
	}
}
