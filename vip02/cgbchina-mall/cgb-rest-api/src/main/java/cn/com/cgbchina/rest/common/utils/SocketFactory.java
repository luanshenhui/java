package cn.com.cgbchina.rest.common.utils;

import java.io.IOException;
import java.net.Socket;
import java.net.UnknownHostException;

public class SocketFactory {

	public static Socket createSocket(String serverName)
			throws NumberFormatException, UnknownHostException, IOException {
		String hostPort = serverName;
		/*
		 * String hostPort = null; CommonType[] ct =Tools.loadConfigFromFile("nnatp",1); for(int i=0; i<ct.length; i++){
		 * if(ct[i].getId().equals(serverName)){ hostPort=ct[i].getValue(); break; } }
		 */
		if (hostPort == null)
			new Exception("没有服务器" + serverName + "的配置信息！");
		String[] segs = hostPort.split(":");
		if (segs.length < 3)
			new Exception("服务器“" + serverName + "”的配置错误，格式为“IP地址:端口号”！");

		System.out.println("afa =" + segs[0] + "  " + segs[1]);
		Socket socket = new Socket(segs[0], Integer.parseInt(segs[1]));
		socket.setSoTimeout(Integer.parseInt(segs[2]) * 1000);
		return socket;
	}
}
