package day01;
/**
 * 字符串常用方法1
 * @author Administrator
 *
 */
public class TestStringMethod {
	public static void main(String[] args) {
		String str = "  HelloWorld		    ";
		String lower = str.toLowerCase();//将字符串转换为小写
		String upper = str.toUpperCase();//将字符串转换为大写
		
		System.out.println("lower:" + lower);
		System.out.println("upper:" + upper);
		
		String trim = str.trim();//去掉字符串两边的空白
		System.out.println("trim:" + trim);
		
		//查看str这个字符串是否以"Hel"开头
		boolean starts = str.startsWith("Hel");
		System.out.println("是以Hel开头:"+starts);
		
		//查看str这个字符串是否已"orld"结尾
//		String trims = str.trim();		
//		boolean ends = trims.endsWith("orld");
		
		//这句等同上面两句
		boolean ends = str.trim().endsWith("orld");
		
		System.out.println("是以orld结尾:"+ends);
		
		
		/**
		 * 忽略大小写比较
		 * 查看字符串是否以hell开头
		 * 
		 * 思路:
		 *   判断时只要让原来字符串都变成小写字母，在和这个字符串
		 *   比较就可以了
		 *   HelloWorld ===>  helloworld
		 */
		//1 先去掉原来字符串的两侧的空白
		String trimStr = str.trim();
		//2 将字符串转换为纯小写
		String lowerStr = trimStr.toLowerCase();
		//3 判断是否以hell开头
		boolean start = lowerStr.startsWith("hell");
		System.out.println("是否以hell开头:"+start);
		//下面这句等同上面三句
		start = str.trim().toLowerCase().startsWith("hell");
		
		System.out.println("字符串长度:"+str.length());
	}
}







