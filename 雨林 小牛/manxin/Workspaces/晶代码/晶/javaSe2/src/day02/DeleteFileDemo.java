package day02;

import java.io.File;

/**
 * ɾ���ļ���Ŀ¼
 * @author Administrator
 *
 */
public class DeleteFileDemo {
	public static void main(String[] args) {
		/**
		 * ɾ����Ŀ��Ŀ¼�µ�file.txt�ļ�
		 */
		//1 ����File������������Ҫɾ�����ļ�
		File file = 
			new File("."+File.separator+"file.txt");
		
		//2 ɾ���ļ�
		file.delete();
		
		System.out.println("ɾ�����");
	
	}
}







