package day04;

import java.math.BigDecimal;

/**
 * BigDecimalDemo���ڼ������ȷ��С��
 * ͬʱҲ���Ա�ʾһ���ܾ�ȷ��С��
 * @author Administrator
 *
 */
public class BigDecimalDemo {
	public static void main(String[] args) {
		BigDecimal num1 = new BigDecimal("3.0");
		BigDecimal num2 = new BigDecimal("2.9");
		BigDecimal num3 = num1.subtract(num2);
		System.out.println(num3);
		
		/**
		 * ����Ҫע�⣬ͨ�����ǻ�ʹ�ó��������ط���
		 * �������ģʽ��(��������)
		 * ������������ô�����������������Ϊ����С��ʱ
		 * ��һ�³���ȥ��ֱ������
		 */
		BigDecimal num4 
				= num1.divide(num2,9,BigDecimal.ROUND_HALF_UP);
		System.out.println(num4);
	}
}





