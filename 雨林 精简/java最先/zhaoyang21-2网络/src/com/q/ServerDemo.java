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
	 * TCP/IP�Ĳ�ģ�ͣ�Ӧ�ò㣬����㣬Internet�㣬������ʲ㡣
	 * C/S�ܹ���Client�ͻ���/Server�������ܹ�
	 * B/S�ܹ���Brower�����(�ͻ���)/Server�������ܹ�
	 * 
	 * ģ���������
	 */
	public static void main(String[] args) {
		//ip��ַ���Ϊ�����ţ��˿����Ϊ�ֻ���
		try {
			//1)�������������׽���
			//���������Ķ˿�
			ServerSocket server=new ServerSocket(8888);
		//2)���տͻ������󣬷����׽���(���ݰ�)
			Socket socket=server.accept();
		//3)InputStream��������ͨ��socket��ȡ������(��)�������(д)(�ֽڵĶ�д)
			InputStream in=socket.getInputStream();	
			OutputStream out=socket.getOutputStream();//�Ϳ������ͻ��������Ϣ
		//4)��ȡ���������������������(װ��ģʽ)��DateInputStream��ʾ����ģʽ
			DataInputStream din=new DataInputStream(in);
			DataOutputStream dou=new DataOutputStream(out);
			
		//5)����ͻ��˷��͹�������Ϣ(����UTF�����ȡ��Ϣ)
			System.out.println(din.readUTF());
		//6)��ͻ�����Ӧ����(���)	
			dou.writeUTF("��ӭ���ʱ�����");
			//7)�ر�io��
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
