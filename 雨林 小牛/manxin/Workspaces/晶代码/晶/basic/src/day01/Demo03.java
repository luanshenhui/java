package day01;
/**
 * ��ϸ��float double �ļ������ο� IEEE 754 ��׼
 * 1) ����float ���ȱȽϲ����ʹ��,���ʹ��double
 *
 * ���ȣ�β�����Ⱦ���
 * ��С��Χ��ָ����С����λ�ã�����
 *  a = 3.1415926535897932384626433832
 *  b = 3.1415926535897 * 100
 *  
 *  float �ľ��� û�� int �ߣ�����float�Ĵ�С��Χ��int��
 * 2) ������������Ĭ����double ����
 *   DΪ��׺��double  f ��׺��float 
 */
public class Demo03 {
  public static void main(String[] args) {
    float fa = 5;
    float fb = 5;
    float fc = fa + fb;
    System.out.println(fc);//10.0
    int a = 0x7fffffff;
    int b = 0x7ffffff0;
    System.out.println(a-b);//15
    fa = a;//��ʧ���ȣ��������
    fb = b;
    System.out.println(a+"aaaaaaaaa");
    System.out.println(b);
    System.out.println(fa);
    System.out.println(fb);
    System.out.println(fa-fb+"bbbbbb");//˵��float���Ȳ��ߣ������
    System.out.println(a+b);//����int��Χ���������
    System.out.println(fa+fb);//float ��Χ��int��
    
    double da = a;
    double db = b;
    System.out.println(da-db);
    System.out.println(da+db);
    
    
    //IEEE 754����
    //Ĭ�ϵĸ�������������double ����
    double pi = 3.1415926535897932384;
    //float f = 3.1415926535897932384;//�������
    //double ���������ܸ�ֵ��float
    float f = 3.1415926535897932384F;
    System.out.println(pi);
    System.out.println(f);
    
    //ע������ 1 1L 1.0 1D 1F 
    //����������Ĳ���ȷ��, ����ʹ�ø��������о�ȷ����
    
    double x = 2.6;
    double y = x - 2;
    System.out.println(y); 
    
  }
}








