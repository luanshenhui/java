package day02;
/**
 * ����(��)���� ++ -- 
 *   �����ǽ�������ֵ��������1(����1)
 */
public class Demo03 {
  public static void main(String[] args) {
    int a = 1;
    a++;
    System.out.println(a);//2
    ++a;
    System.out.println(a);//3
    int b;
    a = 1;
    //a++: ��++, ��ȡaֵ,Ȼ������ 
    b = (a++);//��������, ����ִ��++ ����, Ȼ��ִ�и�ֵ=����
    //ִ��˳��ο�: b = (a++) 
    // ++����  1) ��ȡ"a"��ֵ1 ��Ϊ"a++���ʽ"��ֵ1
    // ++����  2) Ȼ��a��ֵ����1, aΪ2
    // = ����  3) ��"a++ ���ʽ"��ֵ1 ��ֵ�� bΪ1
    System.out.println(a+","+b); //2,1
    a = 1;
    a = a++;//��������, ����ִ��++ ����, Ȼ��ִ�и�ֵ=����
    // ++����  1) ��ȡa��ֵ1 ��Ϊ"a++���ʽ"��ֵ1
    // ++����  2) Ȼ��a��ֵ����1, aΪ2
    // = ����  3) ��"a++ ���ʽ"��ֵ1 ��ֵ�� aΪ1
    System.out.println(a);//1
    a = 1;
    System.out.println(a++); //1
    System.out.println(a); //2
    
    
    
  }
}







