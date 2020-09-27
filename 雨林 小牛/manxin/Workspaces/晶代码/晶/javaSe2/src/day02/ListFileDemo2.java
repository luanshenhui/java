package day02;

import java.io.File;

/**
 * 列出给定File下的所有子项
 * @author Administrator
 *
 */
public class ListFileDemo2 {
	public static void main(String[] args) {
		File dir = new File(".");
		listFile(dir);
	}
	/**
	 * 列出给定File对象的所有子项名称
	 * @param file
	 */
	public static void listFile(File file){
		if(file.isDirectory()){
			System.out.print("目录:");
		}else{
			System.out.print("文件:");
		}
		//输出file对象描述的文件或目录的名字
		System.out.println(file.getName());
		/**
		 * 判断当前给定的File对象是否为一个目录
		 * 是目录才列出所有子项
		 */
		if(file.isDirectory()){
			File[] subs = file.listFiles();
			for(File sub : subs){
				listFile(sub);
			}
		}
		
	}
}







