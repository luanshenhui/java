package test;

public class Demo7 {
	public static void main(String[] args) {
		//���������add�������  ��ô��addǰ��û��static����  ���Բ�����ֱ�ӵ���
		// ��ô��������� ��ô���أ�
		//java��һ��������������  ʲô���������  
		/*
		 * ��������������ĸ���   ���� ���� ���   ���� ���� ����
		 * ��java һ�ж����ɶ������  �ɶ�������������
 		 */
		//�ȴ���һ������  ��ʱ a���Ǵ�����һ������
		//����  ������  = new ����������
		Demo7 a = new Demo7();
		int z = a.add(1, 2);
		System.out.println(z);
		a.fang(2);
	}
	
	public int add(int a,int b){
		int c = a + b;
		return c;
	}
	//�����ķ���ֵΪ�� void  ����void ��ô���еķ��������涼Ҫ��return
	public void fang(int qiu){
		System.out.println("ssss");
		System.out.println(1);
	}
}
