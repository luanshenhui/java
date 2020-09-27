package com.yulin.am;
import java.io.*;

public class IODemo1 {

	/**
	 * ������д��
	 */
	public static void main(String[] args) {
		File file = new File("src/user.txt");
		try {
			if(!file.exists()){//ֻ�����������ļ�
				file.createNewFile();
			}
			User user = new User("�ŷ�", 18);
			System.out.println(user);
			FileOutputStream fos = new FileOutputStream(file, true);
			ObjectOutputStream oos = new ObjectOutputStream(fos);
			oos.writeObject(user);//������userд���ļ�
			
			oos.close();
			fos.close();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

}
