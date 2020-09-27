package day02;

import java.io.File;
import java.io.IOException;
import java.io.RandomAccessFile;

/**
 * ʹ��RandomAccessFile���ļ�����д����
 * @author Administrator
 *
 */
public class RandomAccessFileDemo1 {
	public static void main(String[] args) {
		//1 ����Ҫд����Ϣ���ļ�
		//���� ��./�� Ĭ��Ҳ���ڵ�ǰĿ¼�¡�
		File file = new File("raf.dat");
		
		//2 �������ļ�
		if(!file.exists()){
			try {
				file.createNewFile();
			} catch (IOException e) {
				e.printStackTrace();
				System.out.println("�ļ�����ʧ��!");
				return;
			}
		}
		
		//3 ����RandomAccessFile
		RandomAccessFile raf = null;
		try {
			//ʵ����
			raf = new RandomAccessFile(file,"rw");
			
			//дһ��intֵ
			int a = Integer.MAX_VALUE;// 7f ff ff ff
			/**    
			 *                            vvvvvvvv
			 *    7f       ff       ff       ff
			 * 01111111 11111111 11111111 11111111
			 * 
			 * a>>>24
			 * 00000000 00000000 00000000 01111111
			 * 
			 * a>>>16
			 * 00000000 00000000 01111111 11111111
			 * 
			 * a>>>8 
			 * 00000000 01111111 11111111 11111111
			 */
		  //�����8λд���ļ���
			raf.write(a>>>24);// a>>>24  00 00 00 7f 
			raf.write(a>>>16);// a>>>16  00 00 7f ff
			raf.write(a>>>8); // a>>>8   00 7f ff ff
			raf.write(a);
			/**
			 * д�����������ݵķ���
			 */
			raf.writeInt(a);//��ͬ����4��
			raf.writeLong(1L);//һ��д8�ֽڣ���longд���ļ�
			
			//д��'A'
			raf.write('A');
			raf.write('B');
			
			//дһ���ַ���
			String info = "��Һã���Ҫ��д���ļ�����!";
			//���ַ�������gbk����ת��Ϊ�ֽ�
			byte[] data = info.getBytes("GBK");
			raf.write(data);
			
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally{
			if(raf != null){			
					try {
						raf.close();
					} catch (IOException e) {
						e.printStackTrace();
					}			
			}
		}
		
	}
}




