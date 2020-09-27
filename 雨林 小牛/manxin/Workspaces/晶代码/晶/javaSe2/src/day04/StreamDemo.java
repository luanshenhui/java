package day04;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;

/**
 * 高级流处理高级流可以叠加效果
 * @author Administrator
 *
 */
public class StreamDemo {
	public static void main(String[] args)throws IOException {
		/**
		 * 首先，创建用于写文件的低级流FOS
		 */
		FileOutputStream fos = 
			new FileOutputStream("stream.dat");
		
		/**
		 * 将FOS变成BOS，这样可以增加缓冲效果，提高
		 * 写效率
		 */
		BufferedOutputStream bos = 
			new BufferedOutputStream(fos);
		
		/**
		 * 可以方便的写基本类型数据的流DOS
		 */
		DataOutputStream dos = 
			new DataOutputStream(bos);
		
		
		/**
		 * 将基本类型数据转化为对应的字节序列
		 * 以上的过程---基本类型数据的序列化
		 * 
		 * 将这些字节序列写入了文件进行长期保存
		 * 以上的过程---数据持久化
		 */
		dos.writeInt(123);
		
		
		
//		/**
//		 * flush()的作用是将具有缓冲效果的流的缓冲内容做一次
//		 * 强制写出操作。
//		 */
//		dos.flush();
		/**
		 * 流的close()方法效果都差不多
		 * 1:先清空缓冲区做一次强制性写操作，避免丢数据
		 * 2:将当前高级流处理的流先关闭
		 * 3:将自身关闭
		 */
		dos.close();
		System.out.println("写出完毕");
		
		/**
		 * 创建用于读取文件的FIS
		 */
		FileInputStream fis = 
			new FileInputStream("stream.dat");
		
		/**
		 * 创建具有缓冲功能的BIS
		 */
		BufferedInputStream bis = 
			new BufferedInputStream(fis);
		
		/**
		 * 创建可以读取基本类型数据的DIS
		 */
		DataInputStream dis = 
			new DataInputStream(bis);
		
		
		/**
		 * 将字节序列转换为对应的基本类型数据
		 * 以上的过程---基本类型数据反序列化
		 */
		int i = dis.readInt();
		System.out.println("int="+i);
		
		dis.close();
	}
}







