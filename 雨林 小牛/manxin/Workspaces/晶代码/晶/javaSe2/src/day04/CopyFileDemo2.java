package day04;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;

/**
 * 基于缓冲流进行复制文件的操作
 * @author Administrator
 *
 */
public class CopyFileDemo2 {
	public static void main(String[] args)throws IOException {
		FileInputStream fis 
					= new FileInputStream("jvm.bmp");
		
		BufferedInputStream bis 
					= new BufferedInputStream(fis);
		
		FileOutputStream fos 
					= new FileOutputStream("jvm_copy.bmp");
		
		BufferedOutputStream bos 
					= new BufferedOutputStream(fos);
		
		int d = -1;
		
		while(
				(d = bis.read()) != -1
		){
			bos.write(d);
		}
		
		System.out.println("复制完毕");
		/**
		 * 关闭流的时候，只需要关最外层的高级流即可
		 * 高级流在关闭前，会将它处理的流先关闭后才将自己关闭
		 */
		bos.close();
		bis.close();
		
		
	}
}










