package com.yulin.am;
import java.io.*;

public class IODemo1 {

	/**
	 * 对象流写入
	 */
	public static void main(String[] args) {
		File file = new File("src/user.txt");
		try {
			if(!file.exists()){//只是用来创建文件
				file.createNewFile();
			}
			User user = new User("张飞", 18);
			System.out.println(user);
			FileOutputStream fos = new FileOutputStream(file, true);
			ObjectOutputStream oos = new ObjectOutputStream(fos);
			oos.writeObject(user);//将对象user写入文件
			
			oos.close();
			fos.close();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

}
