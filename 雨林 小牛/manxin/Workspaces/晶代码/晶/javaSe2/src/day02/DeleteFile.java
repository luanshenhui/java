package day02;

import java.io.File;

/**
 * ɾ���������ļ���Ŀ¼
 * @author Administrator
 *
 */
public class DeleteFile {
	public static void main(String[] args) {
		File dir = new File("."+File.separator+"a");
		deleteFile(dir);
	}
	/**
	 * ɾ���������ļ���Ŀ¼
	 * @param file
	 */
	public static void deleteFile(File file){
		/**
		 * Ҫ��ɾ��������File����
		 * Ҫ���ж�����һ���ļ�����Ŀ¼
		 * �����ļ������ֱ��ɾ��������Ŀ¼����Ҫ
		 * �Ȼ�ȡ���������Ȼ�����ɾ������ɾ�����Ŀ¼
		 */
		//����Ŀ¼
		if(file.isDirectory()){
			//��ɾ����������
			File[] subs = file.listFiles();
			for(File sub : subs){
				deleteFile(sub);
			}		
		}
		//ɾ����ǰfile�����������ļ���Ŀ¼
		file.delete();

	}
}





