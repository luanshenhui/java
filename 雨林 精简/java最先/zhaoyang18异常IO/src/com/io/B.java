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
			bw.write("你娘个腿，瞪什么眼，看鸡巴看");
			bw.write("\r\n");//r回车，n是换行
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
