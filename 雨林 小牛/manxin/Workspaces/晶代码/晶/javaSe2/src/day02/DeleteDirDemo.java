package day02;

import java.io.File;

/**
 * 删除目录
 * 要确保为空目录才可以删除
 * @author Administrator
 *
 */
public class DeleteDirDemo {
	public static void main(String[] args) {
		/**
		 * 删除项目根目录下的mydir目录
		 */
		File dir = new File("."+File.separator+"a");
		dir.delete();
		System.out.println("删除完毕");
	}
}




