package day01;
import java.math.BigDecimal; 
/**
 * Java �о�ȷС������Ľ������ 
 *  BigDecimal API��ʵ���˾�ȷ�Ķ���С������
 *  �����������м��֣� �����������ͣ����֣� ��������
 *  BigDecimal ��һ����������  ��java�ṩ�˺ܶ���  �����й�����
 *  ����ôȥʹ������������أ�  ���Ҫ��������������뵽��ĸ�.java�ļ���
 *  
 */
public class Demo04 {
  public static void main(String[] args) {
    BigDecimal x = new BigDecimal("2.6");
    BigDecimal y = new BigDecimal("2");
    //subtract ����
    BigDecimal z = x.subtract(y);
    System.out.println(z); 
    z = x.add(y);//��
    System.out.println(z);
    z = x.multiply(y);//�˷�
    System.out.println(z);
    z = x.divide(y); //��
    System.out.println(z);
  }

}
