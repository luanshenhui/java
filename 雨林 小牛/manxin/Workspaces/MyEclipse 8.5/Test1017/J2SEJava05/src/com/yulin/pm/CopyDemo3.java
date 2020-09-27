package com.yulin.pm;
import java.io.*;

public class CopyDemo3 {

	/**
	 * byte[]复制文件 考虑缓冲区
	 * 如果剩余字节数大于1024，则创建缓冲区大小为1024
	 * 如果剩余字节数小于1024，则创建缓冲区大小为所剩字节的大小
	 */
	public static void main(String[] args) {
		try {
			String path = "src/com/yulin/pm/IODemo1.java";
			File file1 = new File(path);
			File file2 = new File(file1.getName() + "_copy");
			file2.createNewFile();
			
			FileInputStream fis = new FileInputStream(file1);
			FileOutputStream fos = new FileOutputStream(file2);
			while(fis.available() > 0){
				byte[] buff;
				if(fis.available() >= 1024){
					buff = new byte[1024];
				}else{
					int in = fis.available();
					buff = new byte[in];
				}
				fis.read(buff);
				fos.write(buff);
				System.out.println("复制完成！");
				fis.close();
				fos.close();		
			}
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

}
