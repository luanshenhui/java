package day02;

import java.util.Arrays;

/**
 * 拆分字符串
 * @author Administrator
 *split 讲servlet的时候要使用的、、、
 */
public class SplitString {
	public static void main(String[] args) {
		String str = "ffff 123123 45678 98786 3453";
		String[] array = str.split("\\s");
		System.out.println("共:"+array.length+"项");
		System.out.println(Arrays.toString(array));
		str = "123,456,789,1234,56456,,,,,,,,,,";
		array = str.split(",");
		System.out.println(array.length);
		System.out.println(Arrays.toString(array));
		/**
		 * 重定义图片名
		 */
		String imgName = "111.jpg";
		/**
		 * 步骤:
		 *   1:将图片名根据"."进行拆分
		 *   2:获取图片的后缀名
		 *   3:生成当前系统时间
		 *   4:用当前系统时间加上图片后缀名组成新的图片名
		 *   
		 *   附件重命名，目的2个
		 *   1:避免保存在服务器上时有命名冲突问题
		 *   2:防止XSS攻击  HTML代码注入攻击
		 */
		//1
		String[] names = imgName.split("\\.");
		System.out.println(Arrays.toString(names));
		//2
		String fileName = names[1];
		System.out.println(fileName);
		//3
		long now = System.currentTimeMillis();
		//4
		String newName = now+"."+fileName;
		System.out.println("newName:"+newName);
		
	}
}



















