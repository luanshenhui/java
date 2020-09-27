package day02;

import java.io.File;
import java.io.FileFilter;

/**
 * �ļ�������
 * �����ڻ�ȡһ��Ŀ¼�е�����ʱ����������
 * @author Administrator
 *
 */
public class FileFilterDemo {
	public static void main(String[] args) {
		/**
		 * ����:
		 * ��ȡ��ǰ��Ŀ��Ŀ¼�µ������ı��ļ�
		 */
		File dir = new File(".");
		/**
		 * ���������
		 * java.io.FileFilter
		 */
		FileFilter filter = new FileFilter(){
			public boolean accept(File file) {
				System.out.println("����:"+file.getName());
				String fileName = file.getName();
				return fileName.endsWith(".txt");
			}		
		};
		/**
		 * ��ȡ��ǰĿ¼�����������Ҫ�����������
		 */
		File subs[] = dir.listFiles(filter);
		/**
		 * ���������������
		 */
		for(File sub:subs){
			System.out.println(sub.getName());
		}
		
	}
}







