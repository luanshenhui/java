package day01;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Scanner;

/**
 * 声明方法时可以声明抛出的异常种类，要求调用方必须捕获
 * @author Administrator
 *
 */
public class ThrowsExceptionDemo {
	public static void main(String[] args){
		/**
		 * 通过键盘输入一个日期，转化为毫秒值后输出
		 */
		Scanner scanner = new Scanner(System.in);
		String date = scanner.nextLine();
		/**
		 * 注意，永远不要将throws定义在main方法上！
		 * 将异常抛至虚拟机会导致程序中断。
		 */
		//try {
			try {
				stringToDate(date);
			} catch (ParseException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		//} catch (ParseException e) {
		//	e.printStackTrace();
		//}
		
	}
	/**
	 * 将日期字符串转换为Date后输出毫秒值
	 * @param str
	 * @throws ParseException 
	 * @throws ParseException 
	 */
	public static void stringToDate(String str) throws ParseException{
		SimpleDateFormat format = 
			new SimpleDateFormat("yyyy-MM-dd");
		/**
		 * Date java.text.DateFormat.parse(String source) throws ParseException
		 * parse()方法就声明了throws，要求我们捕获异常
		 * 所以我们看到，这里要是不捕获异常，就会报出
		 * 编译不通过的问题。
		 * 解决办法：
		 * 1:在调用该方法时捕获异常
		 * 2:在当前方法处声明相同的异常抛出
		 */
		Date date = format.parse(str);
		System.out.println(date.getTime());
	}
	
}




