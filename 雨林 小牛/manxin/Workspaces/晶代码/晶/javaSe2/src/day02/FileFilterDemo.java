package day02;

import java.io.File;
import java.io.FileFilter;

/**
 * 文件过滤器
 * 用于在获取一个目录中的子项时，附带条件
 * @author Administrator
 *
 */
public class FileFilterDemo {
	public static void main(String[] args) {
		/**
		 * 需求:
		 * 获取当前项目根目录下的所有文本文件
		 */
		File dir = new File(".");
		/**
		 * 定义过滤器
		 * java.io.FileFilter
		 */
		FileFilter filter = new FileFilter(){
			public boolean accept(File file) {
				System.out.println("过滤:"+file.getName());
				String fileName = file.getName();
				return fileName.endsWith(".txt");
			}		
		};
		/**
		 * 获取当前目录中满足过滤器要求的所有子项
		 */
		File subs[] = dir.listFiles(filter);
		/**
		 * 输出所有子项名字
		 */
		for(File sub:subs){
			System.out.println(sub.getName());
		}
		
	}
}







