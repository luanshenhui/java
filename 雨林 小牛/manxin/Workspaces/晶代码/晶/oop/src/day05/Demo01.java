package day05;

import java.util.Arrays;
/**
 * final ���εı����������޸���
 * final�������͵�����ֵ����ֵַ�������ٸı䣬Ҳ����
 * ���ܸı����ù�ϵ�ˡ����Ǳ����õĶ������Կ��Ը��� 
 */
public class Demo01 {
	public static void main(String[] args) {
	  final int a = 5;//����a��ֵ�����ٴ��޸�
	  //ary �����ñ�����ֵ�ǵ�ֵַ��ͨ����ַ��������� ����
	  final int[] ary = {5,6};//����ary��ֵ�����ٸ���
	  //ary = new int[3];//�������
	  ary[0]+=3;
	  System.out.println(Arrays.toString(ary));//8 6
	  final Foo f = new Foo();
	  //f = null;//�������
	  f.a = 9;
	}
}
class Foo{
	int a = 8;//final a = 8;
}





