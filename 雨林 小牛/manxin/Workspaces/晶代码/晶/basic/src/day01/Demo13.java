package day01;
/**
 * �����ԭ��
 *  1��ͬ�����Ͳ������㣬�ȵ�ͬ�����ͽ��
 *  2��С��32λ����byte, short, char������32λ���� 
 *  3��ע�⣬�����ĳ���������
 */
public class Demo13 {
  public static void main(String[] args) {
    int a = 3;
    int b = 4;
    int c = a+b;
    System.out.println(c);//7
    long l = 5L + a;
    System.out.println(l); //8
    a = 0x7fffffff;
    c = a + 1;
    System.out.println(c);//�����Ϊ��Сֵ��
    l = a + 1;
    System.out.println(l);//�����Ϊ��Сֵ��
    l = (long)a + 1;//��ת�������
    System.out.println(l);//������

    byte b1 = 5;
    byte b2 = 6;
    //byte b3 = b1+b2;//�������
    byte b3 = (byte)(b1+b2);
    
    System.out.println(5/2);// �� 2 �� 1
    System.out.println(5.0/2);
    System.out.println(5D/2);
    System.out.println((double)5/2);
    
    double price = 59.99;
    System.out.println(price * (80/100)); //����
    System.out.println(price * (80.0/100)); //�������
  }
  
}













