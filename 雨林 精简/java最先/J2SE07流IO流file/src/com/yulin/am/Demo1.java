package com.yulin.am;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.ObjectOutputStream;

public class Demo1 {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		File file =new File("src/user");
		try {
		if(!file.exists()){
				file.createNewFile();
			}
		
		User user=new User("张飞",18);
		System.out.println("user");
		FileOutputStream fos=new FileOutputStream(file);
		ObjectOutputStream oos=new ObjectOutputStream(fos);
		oos.writeObject(user);//将对象user写入文件
		
		oos.close();
		fos.close();
	} catch (IOException e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
		// TODO Auto-generated method stub

	}

}
	}
