package day04;
/**
 * ��װ��ķ���
 * @author Administrator
 *
 */
public class IntegerDemo4 {
	public static void main(String[] args) {
		//1 ���ַ���ת��Ϊ������������
		/*
		 * ��������ڻ�õ���string��ô
		 * �㻹�����ת��Ϊint���������Ļ����������͵�ʱ��
		 * ͨ����װ�������ö���Ľ�������
		 * ������Ĳ�����string����
		 * 
		 */
		int a = Integer.parseInt("123");
		double d = Double.parseDouble("12.3");
		/**
		 * Integer�ṩ�˿��Խ�����ת��Ϊ2���ƺ�16���Ʋ���
		 * �ַ���ȥ����
		 */
		String bStr = Integer.toBinaryString(100);
		String hStr = Integer.toHexString(100);
		System.out.println("100��2������ʽ:"+bStr);
		System.out.println("100��16������ʽ:"+hStr);
		/**
		 * ��װ�ೣ�õĳ���
		 * ���ֵ
		 * ��Сֵ
		 */
		int max = Integer.MAX_VALUE;
		int min = Integer.MIN_VALUE;
		double dMax = Double.MAX_VALUE;
	}
}





