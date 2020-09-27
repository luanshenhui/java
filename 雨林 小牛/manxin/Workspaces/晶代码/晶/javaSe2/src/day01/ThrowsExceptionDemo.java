package day01;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Scanner;

/**
 * ��������ʱ���������׳����쳣���࣬Ҫ����÷����벶��
 * @author Administrator
 *
 */
public class ThrowsExceptionDemo {
	public static void main(String[] args){
		/**
		 * ͨ����������һ�����ڣ�ת��Ϊ����ֵ�����
		 */
		Scanner scanner = new Scanner(System.in);
		String date = scanner.nextLine();
		/**
		 * ע�⣬��Զ��Ҫ��throws������main�����ϣ�
		 * ���쳣����������ᵼ�³����жϡ�
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
	 * �������ַ���ת��ΪDate���������ֵ
	 * @param str
	 * @throws ParseException 
	 * @throws ParseException 
	 */
	public static void stringToDate(String str) throws ParseException{
		SimpleDateFormat format = 
			new SimpleDateFormat("yyyy-MM-dd");
		/**
		 * Date java.text.DateFormat.parse(String source) throws ParseException
		 * parse()������������throws��Ҫ�����ǲ����쳣
		 * �������ǿ���������Ҫ�ǲ������쳣���ͻᱨ��
		 * ���벻ͨ�������⡣
		 * ����취��
		 * 1:�ڵ��ø÷���ʱ�����쳣
		 * 2:�ڵ�ǰ������������ͬ���쳣�׳�
		 */
		Date date = format.parse(str);
		System.out.println(date.getTime());
	}
	
}




