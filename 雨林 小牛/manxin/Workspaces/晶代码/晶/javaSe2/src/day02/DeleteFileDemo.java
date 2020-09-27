package day02;

import java.io.File;

/**
 * 删除文件或目录
 * @author Administrator
 *
 */
public class DeleteFileDemo {
	public static void main(String[] args) {
		/**
		 * 删除项目根目录下的file.txt文件
		 */
		//1 创建File对象用于描述要删除的文件
		File file = 
			new File("."+File.separator+"file.txt");
		
		//2 删除文件
		file.delete();
		
		System.out.println("删除完毕");
	
	}
}







