package day02;

import java.io.File;

/**
 * ɾ��Ŀ¼
 * Ҫȷ��Ϊ��Ŀ¼�ſ���ɾ��
 * @author Administrator
 *
 */
public class DeleteDirDemo {
	public static void main(String[] args) {
		/**
		 * ɾ����Ŀ��Ŀ¼�µ�mydirĿ¼
		 */
		File dir = new File("."+File.separator+"a");
		dir.delete();
		System.out.println("ɾ�����");
	}
}




