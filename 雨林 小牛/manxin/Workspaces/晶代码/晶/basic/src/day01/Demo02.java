package day01;
/**
 * double float boolean byte short int long char
 * boolean byte short char int float double long
 * long ����
 * 1) ʹ��L��׺��������(ֱ����) ��long����
 * 2) �����ʱ��涨: long���� ��GMT 1970��Ԫ����ʼ �ۼƵ�
 *    ��������Ϊʱ��, ����涨:��ʱ��ת��Ϊ����long
 * 3) ʹ�� System.currentTimeMillis() ���ϵͳʱ��
 * 4) ʱ����һ��long������
 * 
 * 
 */
public class Demo02 {
  public static void main(String[] args) {
	  
    //current ��ǰ��  Time ʱ�� Millis ������
    //��ȡ��ǰϵͳ(System)��ʱ�������
	//֮ǰ�����Ķ��Ƕ�����÷��� ���Ǵ�ʱ�˿�  û��ʹ�ö�������������Ϊʲô��
	//��ΪcurrentTimeMillis������һ����̬����  ��static���εķ���
	 //��static���εķ�����������  �ǿ���ֱ�����������õ�  ����������
	//�����ķ���ֵ��ʲô  ���Ӧ����ʲô����������
    long now = System.currentTimeMillis();
    System.out.println(now); 
    long year = now/1000/60/60/24/365 + 1970;
    System.out.println(year); 
  }
}



