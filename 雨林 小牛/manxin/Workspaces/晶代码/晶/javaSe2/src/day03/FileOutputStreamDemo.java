package day03;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;

/**
 * �������ļ���д���ݵ������
 * FileOutputStream
 * @author Administrator
 *
 */
public class FileOutputStreamDemo {
	public static void main(String[] args) throws FileNotFoundException {
		/**
		 * ���ļ���д��Ϣ
		 * 
		 * FileNotFoundException
		 * �����Ǹ�����File������������һ��Ŀ¼ʱ
		 * ��File������������һ���ļ��������ڴ���ʱ���ɹ�
		 * ���������������FileNotFoundException
		 */
		//File file = new File("fos.dat");
		FileOutputStream fos = null;						
		try {
			/**
			 * FileOutputStream(File file,booelan append)
			 * ���صĹ��췽��
			 * ��appendΪtrueʱ��ͨ���������д����������׷��
			 * ��file�ļ�ĩβ�ġ�
			 */
//			fos = new FileOutputStream(file,true);	
//			fos = new FileOutputStream("fos.dat");
			fos = new FileOutputStream("fos.dat");
			fos.write('A');
			/**
			 * ��һ���ļ����ж���д����ʱ���ļ��Ĵ�С����
			 * ������д�����ܹ�д������Ϊ׼������ļ�֮ǰ
			 * ������ȫ����������
			 */
			fos.write('C');
			
		} catch (IOException e) {
			e.printStackTrace();
		/**
		 * ���Գ���:final finally finalize������	
		 */
		} finally{
				if(fos != null){
					try {
						fos.close();
					} catch (IOException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
				}				
		}	
	}
}


