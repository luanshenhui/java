package com.yulin.am;
import java.io.*;

public class FileDemo02 {

	/**
	 * ��ʾsrc�������ļ���Ŀ¼�Լ���Ŀ¼�е��ļ�
	 */
	public static void main(String[] args) {
		File file = new File("src");
		look(file);
	}
	
	public static void look(File file){
		if(file.isDirectory()){	//�������ļ���һ��Ŀ¼
			System.out.println("Ŀ¼��" + file);
			for(File f : file.listFiles()){//���Ŀ¼�����е��ļ�
				look(f);
			}
		}else{
			if(file.getName().endsWith(".java")){
				String name = file.getName();
				name = name.replace(".java", ".doc");
				file.renameTo(new File(name));
			}
			System.out.println("�ļ�:" + file);
		}
	}

}
