package day04;

import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;

/**
 * ���ڶ�ȡ�ı��ļ����ֽ�������
 * @author Administrator
 *
 */
public class FileReaderDemo {
	public static void main(String[] args)throws IOException {
		/**
		 * FileReader(File file)
		 * FileReader(String path)
		 */
//		File file = new File("CopyFile.java");
//		FileReader reader = new FileReader(file);
		/**
		 * FileReader�����޸ı��뼶��ֻ�ܰ��յ�ǰϵͳ
		 * Ĭ�ϵı��뼯��ȡ�ı��ļ���
		 */
		FileReader reader 
				= new FileReader("CopyFile.java");
		
		/**
		 * �����������ı��ļ���д�ַ����ַ������
		 * ͬ��Ҫע�⣬�������Ҳ���߱��趨���뼯������
		 */
		FileWriter writer 
				= new FileWriter("CopyFile_copy.java");
		
		int c = -1;
		while(
				(c = reader.read()) != -1
		){
//			System.out.print((char)c);
			writer.write(c);
		}
		reader.close();
		writer.close();
	}
}



