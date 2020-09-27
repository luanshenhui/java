package day03;

import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;

/**
 * 使用文件输入输出流进行文件的复制操作
 * @author Administrator
 *
 */
public class CopyFileDemo {
	public static void main(String[] args) throws IOException {
		FileOutputStream fos 
					= new FileOutputStream("jvm.bmp");
		fos.write(1);
		FileInputStream fis 
		= new FileInputStream("jvm.bmp");
		
		
		/**
		 * 按字节读写  效率低
		 */
//		int d = -1;
//		while(
//				(d = fis.read()) != -1
//		){
//			fos.write(d);
//		}
		/**
		 * 使用缓冲方式读写 效率高
		 */
		byte[] buf = new byte[1024*10];
		int sum = 0;
		while(
				(sum = fis.read(buf)) > 0
		){
			fos.write(buf,0,sum);
		}
		System.out.println("复制完毕");
		fis.close();
		fos.close();
	}
}






