package day02;
/**
 * ȡ�����㣬 ȡģ����
 *  ��ȡ��������е�����
 *  1) ����ȡ��Ľ���� ������0����������ʹ�ã����Կ����У�
 *  2) ��������n�����������ں���������С��n
 *     �ڹ�����, �����Ե����㾭������ % ʵ��
 *     
 *     ++i ++��ǰ����+1  ������
 *     i++ ++�ں���������  ��+1
 */
public class Demo02 {
  public static void main(String[] args) {
    int n = 5;
    int m = n % 3;
    System.out.println(m);//2
    
    System.out.println(-4%3);//-1
    System.out.println(-3%3);//0
    System.out.println(-2%3);//-2
    System.out.println(-1%3);//-1
    System.out.println(0%3);//0
    System.out.println(1%3);//1
    System.out.println(2%3);//2
    System.out.println(3%3);//0
    System.out.println(4%3);//1
    System.out.println(5%3);//2
    System.out.println(6%3);//0
  }
}
