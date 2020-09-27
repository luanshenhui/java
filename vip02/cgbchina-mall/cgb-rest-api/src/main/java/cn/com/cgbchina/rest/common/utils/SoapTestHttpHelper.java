package cn.com.cgbchina.rest.common.utils;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import org.apache.http.HttpException;

import lombok.Setter;
import lombok.extern.slf4j.Slf4j;

@Slf4j
public class SoapTestHttpHelper {
	@Setter
	private static String url = "http://localhost:8081/Test/selectXml";
	@Setter
	private static String memberName = "qwe";

	public static void setUrl(String url) {
		SoapTestHttpHelper.url = url;
	}

	public static void setMemberName(String memberName) {
		SoapTestHttpHelper.memberName = memberName;
	}

	public static String send(String body) throws IOException, HttpException {
		Map<String, String> maps = new HashMap<>();
		maps.put("xml", body);
		maps.put("memberName", memberName);

		String str = HttpClientUtil.getInstance().sendHttpPost(url, maps);
		/*
		 * Map<String, String> mapps = new HashMap<>(); mapps.put("Content-type", "text/xml;charset=GBK");
		 * mapps.put("Connection", "close"); String str = HttpClientUtil.getInstance().sendHttpPost(url, body);
		 */
		return str;
	}

	public static void main(String[] args) throws IOException, HttpException {
		String str = SoapTestHttpHelper
				.send("<?xml version=\"1.0\" encoding=\"GBK\"?><soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:gateway=\"http://www.agree.com.cn/GDBGateway\"><soapenv:Header>\n"
						+ "<gateway:HeadType>\n" + "<gateway:versionNo>1</gateway:versionNo>\n"
						+ "<gateway:toEncrypt>0</gateway:toEncrypt>\n" + "<gateway:commCode>500001</gateway:commCode>\n"
						+ "<gateway:commType>0</gateway:commType>\n" + "<gateway:receiverId>BPSN</gateway:receiverId>\n"
						+ "<gateway:senderId>MALL</gateway:senderId>\n"
						+ "<gateway:senderSN>2016032211050284229831</gateway:senderSN>\n"
						+ "<gateway:senderDate>20160322</gateway:senderDate>\n"
						+ "<gateway:senderTime>110502</gateway:senderTime>\n"
						+ "<gateway:tradeCode>BP1001</gateway:tradeCode>\n"
						+ "<gateway:gwErrorCode></gateway:gwErrorCode>\n"
						+ "<gateway:gwErrorMessage></gateway:gwErrorMessage></gateway:HeadType></soapenv:Header><soapenv:Body>\n"
						+ "<gateway:NoAS400>\n" + "<gateway:field name=\"CASEID\"></gateway:field>\n"
						+ "<gateway:field name=\"SRCCASEID\">201603160937013402</gateway:field>\n"
						+ "<gateway:field name=\"CHANNEL\">070</gateway:field></gateway:NoAS400></soapenv:Body></soapenv:Envelope>");
		System.out.println(str);
	}

	public String getUrl() {
		return url;
	}
}