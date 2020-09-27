package com.q;

import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.IOException;
import java.net.Socket;
import java.net.UnknownHostException;

public class ClientDemo {

	/**
	 * @param args
	 * 模拟的客户端
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		//	1)	创建客户端套接字(ip地址，端口)
		try {
			Socket socket=new Socket("127.0.0.1",8888);
			//2)获取io流
			DataInputStream in=new DataInputStream(socket.getInputStream());
			DataOutputStream out=new DataOutputStream(socket.getOutputStream());
			
			//3读写
			out.writeUTF("你好，我是客户端");
			System.out.println(in.readUTF());//打印服务器来的信息
			//4
			socket.close();
			
		} catch (UnknownHostException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	}

}
