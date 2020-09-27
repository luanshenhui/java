package cn.com.cgbchina.rest.common.utils;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.net.ServerSocket;
import java.net.Socket;

import org.apache.commons.io.FileUtils;

public class SocketServer {
	public static int PORT = 7878;

	public static void main(String[] agrs) {
		ServerSocket s = null;
		Socket socket = null;
		BufferedReader br = null;
		PrintWriter pw = null;
		try {
			// 设定服务端的端口号
			s = new ServerSocket(PORT);
			System.out.println("ServerSocket Start:" + s);
			// 等待请求,此方法会一直阻塞,直到获得请求才往下走
			String xml = FileUtils.readFileToString(new File("D:/zx/电商/02 接口设计/EEA1result.xml"));
			socket = s.accept();
			System.out.println("Connection accept socket:" + socket);
			// 用于接收客户端发来的请求
			br = new BufferedReader(new InputStreamReader(socket.getInputStream()));
			// 用于发送返回信息,可以不需要装饰这么多io流使用缓冲流时发送数据要注意调用.flush()方法
			pw = new PrintWriter(new BufferedWriter(new OutputStreamWriter(socket.getOutputStream())), true);
			pw.println(xml);
			pw.flush();

		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			System.out.println("Close.....");
			try {
				br.close();
				pw.close();
				socket.close();
				s.close();
			} catch (Exception e2) {

			}
		}
	}
}
