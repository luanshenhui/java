package day04;

import java.io.BufferedReader;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.PrintWriter;

/**
 * ��ȡ�����������Ϣ
 * @author Administrator
 *
 */
public class SystemInDemo {
	public static void main(String[] args)throws IOException {
		//��ȡ���˼�����Ϣ��������
		InputStream in = System.in;
		
		//ת��Ϊ�ַ���
		InputStreamReader reader = 
			new InputStreamReader(in);
		
		//ת��Ϊ�����ַ������� ���ж�ȡ
		BufferedReader br = 
			new BufferedReader(reader);
		
		//�����̶�ȡ������Ϣд���ļ�
		FileOutputStream fos = 
			new FileOutputStream("systemin.txt");
		
		//���ֽ��������Ϊ�����ַ������
		PrintWriter writer =
			new PrintWriter(fos);
		
		String str = null;
		while(
				(str = br.readLine())!=null
		){
			if("exit".equals(str)){
				break;
			}
			writer.println(str);
		}
		
		writer.close();
//		br.close();  //���ﲻҪclose()��Ϊ��رռ��̵�������
	}
}







