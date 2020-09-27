package day02;

import java.io.File;
import java.io.IOException;

/**
 * 使用File创建对应的目录
 * @author Administrator
 * 
 * a/b/c/d/e.txt
 *
 */
public class FileMkDirDemo {
	public static void main(String[] args) throws IOException {
		/**
		 * 创建目录
		 * 1:指定想要创建目录的位置以及目录名称，并创建对应
		 *   的File对象
		 * 2:创建前确保该目录是不存在的
		 * 3:通过File对象创建它
		 *   
		 */
		//1
		//当我们创建该对象后，并不代表他描述的目录一定存在
		//这只是java的一个对象，在内存中存在的。
		//是否在硬盘上存在，要进行判断
		File dir = new File("."+File.separator+"mydir");
		
		//2
		if(!dir.exists()){
			//3
			dir.mkdir();
		}
		//输出目录路径
		System.out.println(dir.getCanonicalPath());
		
		/**
		 * 在mydir目录中创建文件test.txt
		 * 创建文件的步骤和创建目录步骤一致
		 */
		//1   ./mydir/test.txt
		File file = 
			new File(
					"." + File.separator +
				  "mydir" + File.separator +
					"test.txt"
				  );
		/**
		 * 重载构造方法
		 * 在指定目录中创建文件或目录
		 * 参数1:描述父目录(上级目录)的File对象
		 * 参数2:当前文件或目录的名字
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







