package day02;

import java.io.File;
import java.util.Arrays;

/**
 * ��ȡĿ¼����������
 * @author Administrator
 *
 */
public class ListFileDemo {
	public static void main(String[] args) {
		//�����ǰ��Ŀ��Ŀ¼�µ���������
		File dir = new File(".");
		System.out.println("dir:"+dir.getName());
		
		//��ȡ�������������
//		String sub_names[] = dir.list();
//		for(String sub:sub_names){
//			System.out.println(sub);
//		}
		
		/**
		 * ��ȡ��������
		 * ע�⣬ȷ��File������������һ��Ŀ¼���ڵ���
		 * listFiles()������
		 */
		File[] subs = dir.listFiles();
		System.out.println(Arrays.toString(subs));
		for(File sub:subs){
			if(sub.isFile()){
				System.out.println("�ļ�:"+sub.getName());
			}else{
				System.out.println("Ŀ¼:"+sub.getName());
			}
		}
	}
}














