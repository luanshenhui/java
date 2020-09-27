package day01;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Collections;
import java.util.Date;

/**
 * File�࣬���������ļ�ϵͳ�е�һ���ļ���Ŀ¼
 * @author Administrator
 *
 */
public class FileDemo {
	public static void main(String[] args) {
		/**
		 * ����һ��File��������������ǰ��Ŀ��Ŀ¼�µ�
		 * file.txt�ļ�
		 * 
		 * ·���е�"."����ǰĿ¼������ָ�ľ��ǵ�ǰ��Ŀ��
		 * ��Ŀ¼��
		 * 
		 *  .\file.txt  window
		 *    
		 *  ./file.txt  linux
		 *  
		 *  File.separator ���������ڽ������ϵͳ��Ŀ¼�ָ���
		 *                 ֮��Ĳ��졣
		 */
		//java.io.File
		/**
		 * ���췽��
		 * File(String path)
		 * ���ݸ�����·��������File��������������ļ���Ŀ¼
		 */
		File file = new File("."+File.separator+"file.txt");
		/**
		 * String getName()
		 * ��ȡ�ļ���Ŀ¼������
		 */
		System.out.println("fileName:" + file.getName());
		
		/**
		 * �ļ���С
		 * long length()
		 */
		System.out.println("length:"+file.length());
		
		/**
		 * �ļ�����޸�ʱ��
		 */
		SimpleDateFormat format = 
			new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date date = new Date(file.lastModified());
		System.out.println("lashModified:"+format.format(date));
		
		/**
		 * ��ȡ�ļ���Ŀ¼��·��
		 * String getPath()
		 */
		System.out.println("path:"+file.getPath());
		/**
		 * ��ȡ�ļ���Ŀ¼�ľ���·��
		 * String getAbsolutePath()
		 */
		System.out.println("abs_path:" + file.getAbsolutePath());
		/**
		 * ��ȡ����ϵͳ��׼�ľ���·��
		 * ���Ǹ÷�����Ҫ���ǲ����쳣
		 * String getCononicalPath()
		 */
			try {
				System.out.println("abs_path2:" + file.getCanonicalPath());
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		
		/**
		 * boolean exists()
		 * �ж��ļ���Ŀ¼�Ƿ���Ӳ���ϴ���
		 */
		System.out.println("�Ƿ����:"+file.exists());
	}
}






