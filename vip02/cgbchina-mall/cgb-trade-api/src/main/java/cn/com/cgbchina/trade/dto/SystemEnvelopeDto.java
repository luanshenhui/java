package cn.com.cgbchina.trade.dto;

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
public class SystemEnvelopeDto  implements Serializable{

	String msgtype = "";//消息类型


	String version = "";//版本

	String shopid = "";//商家ID

	String timestamp = "";//时间戳

	String sign = "";//数字签名






	public String getMsgtype() {
		return msgtype;
	}

	public void setMsgtype(String msgtype) {
		this.msgtype = msgtype;
	}

	public String getShopid() {
		return shopid;
	}

	public void setShopid(String shopid) {
		this.shopid = shopid;
	}

	public String getSign() {
		return sign;
	}

	public void setSign(String sign) {
		this.sign = sign;
	}

	public String getTimestamp() {
		return timestamp;
	}

	public void setTimestamp(String timestamp) {
		this.timestamp = timestamp;
	}

	public String getVersion() {
		return version;
	}

	public void setVersion(String version) {
		this.version = version;
	}

	/**
	 *
	 */
	private static final long serialVersionUID = 1L;

	String method = "";//交易方法

	String result_code = "";//返回结果号

	String result_msg = "";//返回结果说明

	String orderno = "";//(客户交易号)大订单号

	String orderId = "";//小订单号

	String message = "";

	String sum = "";//小订单数量

	String payment = "";//订单总金额

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

	public Map getMessageMap() {
		return messageMap;
	}

	public void setMessageMap(Map messageMap) {
		this.messageMap = messageMap;
	}

	public String getOrderId() {
		return orderId;
	}

	public void setOrderId(String orderId) {
		this.orderId = orderId;
	}







}
