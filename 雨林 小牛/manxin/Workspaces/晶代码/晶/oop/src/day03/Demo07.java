package day03;
/**
 * ջ  ����洢���ǻ����������ͺ����ñ���  �ڴ�����ڶ���˵��С ����� 
 * �Ƚ���� ����ȳ���ԭ�� 
 * ��  ���� ���ڴ�ܴ�  �洢����
 * 
 * ��д�ķ����Ƕ�̬�󶨵��������͵ķ���
 * ��д: �����������븸��ͬ��,ͬ�����ķ���(һ���ķ���)
 *   Ŀ���������޸ĸ������Ϊ(����) ! 
 *   �޸��Ժ�,ִ�е����������ķ���! ����ķ���ʧЧ��
 *   ���������Ǹ�����, ִ�е��Ǹ���ķ���
 */
public class Demo07 {
	public static void main(String[] args) {
		Super obj = new Sub();
		obj.test(5);
		obj = new Super();
		obj.test(5);
	}
}
class Super{//��
	public void test(int a){//����
		System.out.println("Super test(int)");
	}
}
class Sub extends Super{//���
	public void test(int a) {//���豻��дΪ��Ӿ
		System.out.println("Sub test(int)"); 
	}
}
