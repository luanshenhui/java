package com.io;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;

public class B {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		BufferedWriter bw =null;
		FileWriter in = null;
		try {
			File file = new File("f:\\x.txt");
			in = new FileWriter(file,true);
			bw = new BufferedWriter(in);
			for(int i=0;i<9;i++){
			bw.write("������ȣ���ʲô�ۣ������Ϳ�");
			bw.write("\r\n");//r�س���n�ǻ���
			}
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			try {
				bw.close();
				in.close();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}

		}

	}

}
