package cn.com.cgbchina.trade.vo;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 发送到外系统的报文vo
 * @author panhui
 *
 */
public class SystemEnvelopeVo extends OutSysEnvelopeVo implements Serializable{

	/**
	 *
	 */
	private static final long serialVersionUID = 1L;

	String method = "";//交易方法

	String result_code = "";//返回结果号

	String result_msg = "";//返回结果说明

	String orderno = "";//(客户交易号)大订单号

	String orderId = ""; //小订单号

	String message = "";

	String sum = "";//小订单数量

	String payment = "";//订单总金额

	String mobile = "";//电话

	List messageCirculateList = new ArrayList();//里面放map

	Map messageMap = new HashMap();//发送信息和接收返回信息使用
	String format = "";//消息体格式
	String remoteFlag = "";//调用系统标志

	public String getFormat() {
		return format;
	}

	public void setFormat(String format) {
		this.format = format;
	}

	public String getRemoteFlag() {
		return remoteFlag;
	}

	public void setRemoteFlag(String remoteFlag) {
		this.remoteFlag = remoteFlag;
	}

	public Map getMessageMap() {
		return messageMap;
	}

	public void setMessageMap(Map messageMap) {
		this.messageMap = messageMap;
	}

	public List getMessageCirculateList() {
		return messageCirculateList;
	}

	public void setMessageCirculateList(List messageCirculateList) {
		this.messageCirculateList = messageCirculateList;
	}

	public String getMessage() {
		return message;
	}

	public void setMessage(String message) {
		this.message = message;
	}

	public String getSum() {
		return sum;
	}

	public void setSum(String sum) {
		this.sum = sum;
	}

	public String getPayment() {
		return payment;
	}

	public void setPayment(String payment) {
		this.payment = payment;
	}

	public String getMethod() {
		return method;
	}

	public void setMethod(String method) {
		this.method = method;
	}

	public String getOrderno() {
		return orderno;
	}

	public void setOrderno(String orderno) {
		this.orderno = orderno;
	}

	public String getResult_code() {
		return result_code;
	}

	public void setResult_code(String result_code) {
		this.result_code = result_code;
	}

	public String getResult_msg() {
		return result_msg;
	}

	public void setResult_msg(String result_msg) {
		this.result_msg = result_msg;
	}

	public String getOrderId() {
		return orderId;
	}

	public void setOrderId(String orderId) {
		this.orderId = orderId;
	}

	public String getMobile() {
		return mobile;
	}

	public void setMobile(String mobile) {
		this.mobile = mobile;
	}





}
