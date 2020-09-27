package com.yulin.pm;
import java.io.*;

public class FileFilterDemo {

	/**
	 * 文件过滤操作
	 * 将某个src下所有.java为结尾的文件，改成以.doc为结尾
	 * 查询File类和FileFilter类
	 */
	public static void main(String[] args){
		
		/*File file = new File("src");
		File[] fs = file.listFiles(new FileFilter(){	//文件过滤器的使用
			@Override
			public boolean accept(File pathname){
				String name = pathname.getName();
				if(name.endsWith(".java")){
					return true;
				}
				return false;
			}
		});
		for(File f : fs){
			System.out.println(f.getName());
		}*/
		
	}

}
