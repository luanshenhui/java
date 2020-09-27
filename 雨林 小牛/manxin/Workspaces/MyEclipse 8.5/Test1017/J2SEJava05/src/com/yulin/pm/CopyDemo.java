package com.yulin.pm;
import java.io.*;

public class CopyDemo {

	/**
	 * 复制文件
	 */
	public static void main(String[] args) {
		try {
			String path1 = "src/com/yulin/pm/IODemo1.java";
			File file1 = new File(path1);
			
			String path2 = "src/com/yulin/pm/IODemo1_copy.java";
			File file2 = new File(path2);
			file2.createNewFile();
		
			FileInputStream fis = new FileInputStream(file1);
			FileOutputStream fos = new FileOutputStream(file2);
			while(fis.available() > 0){	//还没读取的数据长度
				int in = fis.read();
				fos.write(in);
			}
			System.out.println("复制完成！");
			fis.close();
			fos.close();
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		//找到一个20MB以上的文件，复制至项目文件夹下
		
	}
}
