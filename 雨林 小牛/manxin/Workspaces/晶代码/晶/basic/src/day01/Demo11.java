package day01;
/**
 * TeX 
 */
public class Demo11 {
  public static void main(String[] args) {
  //�Զ�����ת�� Ҳ��Ϊ ��ʽ����ת��
    int i = -1;//i ��32λ��
    long l = i;//l ��64λ��, ��������λ��չ����
    System.out.println(l);//-1
    System.out.println(Integer.toBinaryString(i));
    System.out.println(Long.toBinaryString(l));
    //Long.toBinaryString�����Ĳ�����long���� 
    //��i��long ���Ͳ�������ʱ�������Զ�����ת����
    System.out.println(Long.toBinaryString(i));
    byte b = -1;
    System.out.println(Long.toBinaryString(b));
    System.out.println(Integer.toBinaryString(b));
    b = 5;
    System.out.println(Long.toBinaryString(b));
   //ǿ������ת���� �����͵�С���͵�ת�� 
    l = 5;
    i = (int)l;//��Χ֮�ڵ����Σ�û������
    System.out.println(i);//5
    l = 0x8ff00000005L;
    System.out.println(l); 
    i = (int)l;//����������Χ��������λ�������
    System.out.println(i); 
    //ǿ������ת��Ҳ�ᷢ��������ʧ
    double pi = 3.1415926535897932384 * 10000;
    float f = (float)pi;
    l = (long)pi;
    System.out.println(pi);
    System.out.println(f);
    System.out.println(l);
    l = (long)(pi+0.5);//����ǿ������ת��ʵ�� 4��5��
    System.out.println(l); //4��5��
  }
}













