package day02;

import java.io.File;
import java.io.IOException;

/**
 * �����༶Ŀ¼
 * @author Administrator
 *
 */
public class FileMkDirDemo2 {
	public static void main(String[] args) throws IOException {
		/**
		 * �ڵ�ǰĿ¼�´��� a/b/c/d
		 */
		File dir = new File(
				"." + File.separator +
				"a" + File.separator +
				"b" + File.separator +
				"c" + File.separator +
				"d"
		);
		
		if(!dir.exists()){
			//ʹ��mkdir����Ŀ¼�����뱣֤�ϼ�Ŀ¼Ҫ����
//			dir.mkdir();
			//mkdirs����Ŀ¼�����Զ��������ڵ��ϼ�Ŀ¼��������
			dir.mkdirs();
		}
		
		System.out.println("Ŀ¼�������");
		
		File file = new File(dir,"test.txt");
		if(!file.exists()){
			file.createNewFile();//�����ļ�Ҫ����IO�쳣
		}
		System.out.println("�ļ��������");
	}
}








