package day04;
/**
 * ����(Method)��������ѧ����(Function)
 *  ����: ҵ���棺 �ǹ��ܣ��Ƕ�����һ����ö�������
 *   ���ݲ��棺�������㷨��������ģ�ͣ�ʵ��ҵ����
 *   �������������㷨��
 * �������﷨��
 *   1) ���������ж��壡�������ٷ����ж��巽����
 *   2) �������������δ� public static(�Ժ����������γ̽�)
 *   3) ������Ҫ������ȷ�ķ���ֵ���ͣ����û�з���ֵvoid����
 *   4) �����з�����(distance), ϰ��������ĸСд���ڶ���
 *     ���ʿ�ʼ����ĸ��д���磺getUserName()
 *   5) ���������б� (int x1, int y1, int x2, int y2) 
 *     �Ƿ�������ʵ�ֵ�ǰ��������
 *   6) {} �Ƿ����壬�Ƿ������㷨��������
 *     ������������ķ���ֵ�������ڷ�����ʹ��return ���
 *     �������ݣ�
 *   7) ʹ�÷��������÷�����ִ�з����Ĺ��ܡ�
 */
public class Demo07 {
	public static void main(String[] args) {
		double s = distance(3, 4, 6, 8);//�����ĵ���
		System.out.println(s); 
		s = distance(0, 0, 5, 5);
		System.out.println(s); 
	}
	/** �������(distance)�ķ�������װ�˼������Ĺ���*/
	public static double distance(
			int x1, int y1, int x2, int y2){
		int a = x1-x2; int b = y1-y2;
		return Math.sqrt(a*a + b*b);//����
	}
}




