package cn.com.cgbchina.rest.common.connect;

import java.io.Serializable;
import java.io.UnsupportedEncodingException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import cn.com.cgbchina.rest.common.constants.Constant;
import cn.com.cgbchina.rest.common.exception.ConnectErrorException;
import cn.com.cgbchina.rest.common.utils.CommunicationNatp;
import cn.com.cgbchina.rest.common.utils.HttpClientUtil;
import cn.com.cgbchina.rest.common.utils.PropertieUtils;
import cn.com.cgbchina.rest.common.utils.SocketClient;
import lombok.extern.slf4j.Slf4j;

@Slf4j
public class ConnectOtherSys implements Serializable {

	private static final long serialVersionUID = -7954381041992107736L;
	private static String smsIp = PropertieUtils.getParam().get("connect.smsIp");

	private static Integer smsPort = Integer.valueOf(PropertieUtils.getParam().get("connect.smsPort"));

	private static String pwdIp = PropertieUtils.getParam().get("connect.pwdIp");

	private static Integer pwdPort = Integer.valueOf(PropertieUtils.getParam().get("connect.pwdPort"));

	private static String gatewayUrl = PropertieUtils.getParam().get("connect.gatewayUrl");

	private static String ebankUrl = PropertieUtils.getParam().get("connect.ebankUrl");

	private static String ebankSuffix = ".do";

	public static String connectSoapSys(String xml) {
		try {
			log.info("【柜面网关系统[" + gatewayUrl + "]发送的的xml报文】\n" + xml);
			Map<String, String> mapps = new HashMap<>();
			mapps.put("Content-type", "text/xml;charset=GBK");
			mapps.put("Connection", "close");
			String result = HttpClientUtil.getInstance().sendHttpPost(gatewayUrl, xml, mapps, Constant.CHARSET_GBK);
			log.info("【柜面网关系统[" + gatewayUrl + "]返回的的xml报文】\n" + result);
			return result;
		} catch (RuntimeException e) {
			throw new ConnectErrorException(e);
		}
	}

	public static String connectXmlSys(String xml, String name) {
		String url = name;
		try {
			log.info("【行外系统[" + name + "]请求的xml报文】\n" + xml);
			String result = HttpClientUtil.getInstance().sendHttpPost(url, xml);
			log.info("【行外系统[" + name + "]返回的xml报文】\n" + result);
			return result;
		} catch (RuntimeException e) {
			String string = name + "[行外系统请求的xml报文]" + xml + e.getMessage();
			throw new ConnectErrorException(string, e);
		}
	}

	public static String connectEBank(Map<String, String> xml, String code) {
		// ebankUrl="http://21.96.60.104:8084/perbank/" ;
		String url = ebankUrl + code + ebankSuffix;
		if (code.equals("EBOT04") || code.equals("EBOT12") || code.equals("EBOT13") || code.equals("EBAC02")) {
			url = ebankUrl + "mobile/" + code + ebankSuffix;
		}

		try {
			log.info("【请求个人网银系统[" + url + "]的xml报文】:\n" + xml);
			String res = HttpClientUtil.getInstance().sendHttpPost(url, xml);

			log.info("【请求个人网银[" + url + "]返回数据】:" + res);
			return res;
			// return HttpClientUtil.getInstance().sendHttpPost(
			// "http://21.96.165.29:9081/perbank/mobile/" + code + ebankSuffix,
			// xml);
			/*
			 * return HttpClientUtil.getInstance().sendHttpPost( ebankUrl + code + ebankSuffix, xml);
			 */
		} catch (RuntimeException e) {
			String string = e.getMessage() + "\n访问的URl是" + url + "\n [发出的为]" + xml;
			throw new ConnectErrorException(string, e);
		}
	}

	public static String connectSMS(byte[] sendData) {
		List<String> list = SocketClient.sendNatp(sendData, smsIp, smsPort);
		return list.get(0);
	}

	public static String connectPwd(String xml) {
		byte[] res = SocketClient.sendSocket(xml, pwdIp, pwdPort);
		try {
			String c = new String(res, "GBK");
			return SocketClient.parseXml(c);
		} catch (UnsupportedEncodingException e) {
			throw new ConnectErrorException(e);
		}
	}

	public static String connectSMS(CommunicationNatp natp) {

		try {
			// 5为超时时间
			return natp.exchange_result(smsIp + ":" + smsPort + ":5");
		} catch (Exception e) {
			throw new RuntimeException("发送短信报文出错 " + smsIp + ":" + smsPort, e);
		}

	}

	public static void main(String[] args) {
		String res = SocketClient.send(
				"<?xml version=\"1.0\" encoding=\"GBK\"?>  <union>    <head>      <serviceCode>0001</serviceCode>      <userID>0001</ serID >      <transFlag>1</transFlag>    </head>    <body>      <data>test</data>   </body> </union>",
				"10.2.37.244", 8805);
		System.out.println(res);
	}
}
