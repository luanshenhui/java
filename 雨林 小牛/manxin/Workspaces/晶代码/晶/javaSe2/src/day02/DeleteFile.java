package day02;

import java.io.File;

/**
 * 删除给定的文件或目录
 * @author Administrator
 *
 */
public class DeleteFile {
	public static void main(String[] args) {
		File dir = new File("."+File.separator+"a");
		deleteFile(dir);
	}
	/**
	 * 删除给定的文件或目录
	 * @param file
	 */
	public static void deleteFile(File file){
		/**
		 * 要想删除给定的File对象
		 * 要先判断它是一个文件还是目录
		 * 若是文件则可以直接删除，若是目录，则要
		 * 先获取其所有子项，然后逐个删除后，再删除这个目录
		 */
		//若是目录
		if(file.isDirectory()){
			//先删除所有子项
			File[] subs = file.listFiles();
			for(File sub : subs){
				deleteFile(sub);
			}		
		}
		//删除当前file对象描述的文件或目录
		file.delete();

	}
}





