package day02;

import java.io.File;

/**
 * �г�����File�µ���������
 * @author Administrator
 *
 */
public class ListFileDemo2 {
	public static void main(String[] args) {
		File dir = new File(".");
		listFile(dir);
	}
	/**
	 * �г�����File�����������������
	 * @param file
	 */
	public static void listFile(File file){
		if(file.isDirectory()){
			System.out.print("Ŀ¼:");
		}else{
			System.out.print("�ļ�:");
		}
		//���file�����������ļ���Ŀ¼������
		System.out.println(file.getName());
		/**
		 * �жϵ�ǰ������File�����Ƿ�Ϊһ��Ŀ¼
		 * ��Ŀ¼���г���������
		 */
		if(file.isDirectory()){
			File[] subs = file.listFiles();
			for(File sub : subs){
				listFile(sub);
			}
		}
		
	}
}







