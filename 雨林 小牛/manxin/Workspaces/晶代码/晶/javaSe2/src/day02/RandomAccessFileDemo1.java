package day02;

import java.io.File;
import java.io.IOException;
import java.io.RandomAccessFile;

/**
 * 使用RandomAccessFile对文件进行写操作
 * @author Administrator
 *
 */
public class RandomAccessFileDemo1 {
	public static void main(String[] args) {
		//1 创建要写入信息的文件
		//不加 “./” 默认也是在当前目录下。
		File file = new File("raf.dat");
		
		//2 创建该文件
		if(!file.exists()){
			try {
				file.createNewFile();
			} catch (IOException e) {
				e.printStackTrace();
				System.out.println("文件创建失败!");
				return;
			}
		}
		
		//3 创建RandomAccessFile
		RandomAccessFile raf = null;
		try {
			//实例化
			raf = new RandomAccessFile(file,"rw");
			
			//写一个int值
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
		  //将最高8位写到文件中
			raf.write(a>>>24);// a>>>24  00 00 00 7f 
			raf.write(a>>>16);// a>>>16  00 00 7f ff
			raf.write(a>>>8); // a>>>8   00 7f ff ff
			raf.write(a);
			/**
			 * 写基本类型数据的方法
			 */
			raf.writeInt(a);//等同上面4句
			raf.writeLong(1L);//一次写8字节，将long写入文件
			
			//写个'A'
			raf.write('A');
			raf.write('B');
			
			//写一个字符串
			String info = "大家好！我要被写到文件里了!";
			//将字符串按照gbk编码转换为字节
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




