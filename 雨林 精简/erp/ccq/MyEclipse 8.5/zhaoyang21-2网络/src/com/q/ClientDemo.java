package com.q;

import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.IOException;
import java.net.Socket;
import java.net.UnknownHostException;

public class ClientDemo {

	/**
	 * @param args
	 * ģ��Ŀͻ���
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		//	1)	�����ͻ����׽���(ip��ַ���˿�)
		try {
			Socket socket=new Socket("127.0.0.1",8888);
			//2)��ȡio��
			DataInputStream in=new DataInputStream(socket.getInputStream());
			DataOutputStream out=new DataOutputStream(socket.getOutputStream());
			
			//3��д
			out.writeUTF("��ã����ǿͻ���");
			System.out.println(in.readUTF());//��ӡ������������Ϣ
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
