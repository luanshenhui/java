package com.q;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.ServerSocket;
import java.net.Socket;
import java.io.DataInputStream;
import java.io.DataOutputStream;

public class ServerDemo {

	/**
	 * TCP/IP四层模型：应用层，传输层，Internet层，网络访问层。
	 * C/S架构：Client客户端/Server服务器架构
	 * B/S架构，Brower浏览器(客户端)/Server服务器架构
	 * 
	 * 模拟服务器端
	 */
	public static void main(String[] args) {
		//ip地址理解为主机号，端口理解为分机号
		try {
			//1)创建服务器端套接字
			//参数监听的端口
			ServerSocket server=new ServerSocket(8888);
		//2)接收客户端请求，返回套接字(数据包)
			Socket socket=server.accept();
		//3)InputStream输入流，通过socket获取输入流(读)，输出流(写)(字节的读写)
			InputStream in=socket.getInputStream();	
			OutputStream out=socket.getOutputStream();//就可以往客户端输出信息
		//4)获取数据输入流，数据输出流(装饰模式)，DateInputStream显示各种模式
			DataInputStream din=new DataInputStream(in);
			DataOutputStream dou=new DataOutputStream(out);
			
		//5)输出客户端发送过来的信息(按照UTF编码读取信息)
			System.out.println(din.readUTF());
		//6)向客户端向应数据(输出)	
			dou.writeUTF("欢迎访问本服务");
			//7)关闭io流
			dou.close();
			din.close();
			out.close();
			in.close();
			socket.close();
			server.close();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	}

}
