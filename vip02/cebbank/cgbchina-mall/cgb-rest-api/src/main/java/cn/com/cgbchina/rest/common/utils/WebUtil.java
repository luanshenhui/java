package cn.com.cgbchina.rest.common.utils;

import java.net.InetAddress;
import java.net.UnknownHostException;

public class WebUtil {
	public static String getlocalIP() {
		try {
			return InetAddress.getLocalHost().getHostAddress();
		} catch (UnknownHostException e) {
			throw new RuntimeException("获取本地失败IP" + e);
		}
	}
}
