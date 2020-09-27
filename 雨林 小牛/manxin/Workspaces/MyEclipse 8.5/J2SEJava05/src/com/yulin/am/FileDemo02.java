package com.yulin.am;
import java.io.*;

public class FileDemo02 {

	/**
	 * 显示src下所有文件、目录以及子目录中的文件
	 */
	public static void main(String[] args) {
		File file = new File("src");
		look(file);
	}
	
	public static void look(File file){
		if(file.isDirectory()){	//如果这个文件是一个目录
			System.out.println("目录：" + file);
			for(File f : file.listFiles()){//获得目录下所有的文件
				look(f);
			}
		}else{
			if(file.getName().endsWith(".java")){
				String name = file.getName();
				name = name.replace(".java", ".doc");
				file.renameTo(new File(name));
			}
			System.out.println("文件:" + file);
		}
	}

}
