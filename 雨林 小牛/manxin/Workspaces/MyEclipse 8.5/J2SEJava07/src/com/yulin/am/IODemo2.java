package com.yulin.am;
import java.io.*;

public class IODemo2 {

	/**
	 * 对象流读取
	 */
	public static void main(String[] args) throws IOException{
		File file = new File("src/user.txt");
		FileInputStream fis = null;
		ObjectInputStream ois = null;
		try {
			fis = new FileInputStream(file);
			ois = new ObjectInputStream(fis);
			User user = (User) ois.readObject();
			System.out.println(user);
		} catch (Exception e) {
			e.printStackTrace();
		}finally{		//关闭流的代码,易出现空指针
			ois.close();
			fis.close();
		}
	}

}
