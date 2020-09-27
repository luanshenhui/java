package day02;

import org.apache.commons.lang3.StringUtils;

/**
 * ʹ��commons-lang.jar�е�StringUtils
 * 
 * @author Administrator
 *
 */
public class TestStringUtils {
	public static void main(String[] args) {
		String str = "hello";
		/**
		 * String repeat(String str,int repeat)
		 * ��������str�ַ����ظ�ָ���κ󷵻�
		 */
		String repeat = StringUtils.repeat(str, 10);
		System.out.println(repeat);
		
		
		/**
		 * String join(Object[] array,String separator)
		 * �������������е�ÿ�������toString����ֵ�ø�����
		 * separator���ӳ�һ���ַ����󷵻�
		 * 
		 * join������String�ṩ��split�Ǹ��������
		 */
		String[] arrays = {"abc","def","ghi"};
		String join = StringUtils.join(arrays,",");
		System.out.println(join);
		
		
		/**
		 * String leftPad(String str,int size,char padChar)
		 * ���������ַ������油��padChar�ַ���ֱ���ַ����ﵽsize
		 * ����Ϊֹ��
		 */
		String leftPad 
							= StringUtils.leftPad("hello", 10,'*');
		System.out.println(leftPad);
		
		/**
		 * String rightPad(String str,int size,char padChar)
		 * 
		 */
		String rightPad 
							= StringUtils.rightPad("hello",10,'*');
		System.out.println(rightPad);
	}
}







