package day03;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;

/**
 * 用于向文件中写数据的输出流
 * FileOutputStream
 * @author Administrator
 *
 */
public class FileOutputStreamDemo {
	public static void main(String[] args) throws FileNotFoundException {
		/**
		 * 向文件中写信息
		 * 
		 * FileNotFoundException
		 * 当我们给定的File对象描述的是一个目录时
		 * 或File对象描述的是一个文件，但是在创建时不成功
		 * 这两种情况会引发FileNotFoundException
		 */
		//File file = new File("fos.dat");
		FileOutputStream fos = null;						
		try {
			/**
			 * FileOutputStream(File file,booelan append)
			 * 重载的构造方法
			 * 当append为true时，通过该输出流写出的数据是追加
			 * 到file文件末尾的。
			 */
//			fos = new FileOutputStream(file,true);	
//			fos = new FileOutputStream("fos.dat");
			fos = new FileOutputStream("fos.dat");
			fos.write('A');
			/**
			 * 对一个文件进行二次写操作时，文件的大小会以
			 * 最后这次写操作总共写的内容为准，会把文件之前
			 * 的数据全部废弃掉。
			 */
			fos.write('C');
			
		} catch (IOException e) {
			e.printStackTrace();
		/**
		 * 面试常问:final finally finalize的区别	
		 */
		} finally{
				if(fos != null){
					try {
						fos.close();
					} catch (IOException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
				}				
		}	
	}
}


