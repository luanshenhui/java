package day02;

import java.io.File;
import java.io.IOException;

/**
 * ʹ��File������Ӧ��Ŀ¼
 * @author Administrator
 * 
 * a/b/c/d/e.txt
 *
 */
public class FileMkDirDemo {
	public static void main(String[] args) throws IOException {
		/**
		 * ����Ŀ¼
		 * 1:ָ����Ҫ����Ŀ¼��λ���Լ�Ŀ¼���ƣ���������Ӧ
		 *   ��File����
		 * 2:����ǰȷ����Ŀ¼�ǲ����ڵ�
		 * 3:ͨ��File���󴴽���
		 *   
		 */
		//1
		//�����Ǵ����ö���󣬲���������������Ŀ¼һ������
		//��ֻ��java��һ���������ڴ��д��ڵġ�
		//�Ƿ���Ӳ���ϴ��ڣ�Ҫ�����ж�
		File dir = new File("."+File.separator+"mydir");
		
		//2
		if(!dir.exists()){
			//3
			dir.mkdir();
		}
		//���Ŀ¼·��
		System.out.println(dir.getCanonicalPath());
		
		/**
		 * ��mydirĿ¼�д����ļ�test.txt
		 * �����ļ��Ĳ���ʹ���Ŀ¼����һ��
		 */
		//1   ./mydir/test.txt
		File file = 
			new File(
					"." + File.separator +
				  "mydir" + File.separator +
					"test.txt"
				  );
		/**
		 * ���ع��췽��
		 * ��ָ��Ŀ¼�д����ļ���Ŀ¼
		 * ����1:������Ŀ¼(�ϼ�Ŀ¼)��File����
		 * ����2:��ǰ�ļ���Ŀ¼������
		 */
//		File file = new File(dir,"text.txt");
		//2
		if(!file.exists()){
			//3
			file.createNewFile();
		}
		System.out.println(file.getCanonicalPath());
	}
}







