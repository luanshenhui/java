package day01;
import java.util.Scanner;
/**
 * ��������ʱ�䣬�������������˶���λ��
 *  ���ݣ�ʱ�� t ��λ �룬 ���ͣ�������
 *       �������ٶȣ�g = 9.8  ���ͣ�������
 *       λ�ƣ�s ��λ�ף����͸�����
 *   ��ʽ�� s = (g * t * t) /2 
 *   
 *   ��ʽ��t = Math.sqrt((2*s)/g);
 *   Math.sqrt() ��Java API �ṩ�Ŀ�ƽ������
 */
public class Demo05 {
  public static void main(String[] args) {
	  //����̨����  �ڿ���̨�Ͽ�������һ����
    Scanner console = new Scanner(System.in);
    System.out.print("��������ʱ�䣺");
    double t = console.nextDouble();//�ӿ���̨��ȡdouble����
    double g = 9.8;
    double s;
    s = (g*t*t)/2;
    System.out.println("λ�ƣ�"+s);
  }
}





