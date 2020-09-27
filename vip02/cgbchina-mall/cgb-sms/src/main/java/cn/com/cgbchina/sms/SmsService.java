package cn.com.cgbchina.sms;

import cn.com.cgbchina.sms.Exception.SmsException;

import javax.xml.ws.Response;

/**
 * @author 11140721050130
 * @version 1.0
 * @created at 2016/6/14.
 */
public interface SmsService {

	/**
	 * 发送单条信息
	 *
	 * @param from 发送方
	 * @param to 接收方手机号码
	 * @param message 消息体
	 * @throws SmsException 异常
	 */
	Response<Boolean> sendSingle(String from, String to, String message);

	/**
	 * 群发信息
	 *
	 * @param from 接收方
	 * @param to 接受方手机号码列表
	 * @param message 消息体
	 * @throws SmsException 异常
	 */
	Response<Boolean> sendGroup(String from, Iterable<String> to, String message);

}
