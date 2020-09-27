package day05;
/**
 * �ӿ�: ����һ�����������, ȫ���������ǳ��󷽷�,
 *   ȫ�����Զ��ǳ���.
 * ��ҵ���߼��ϱ�ʾ���������.�����������ṹ������ƹ���.
 * 1) ���Զ������,��������ʵ��
 * 2) ����ֱ�Ӵ�������
 * 3) ֻ�ܱ�ʵ��(һ�ּ̳й�ϵ) 
 * 4) �ӿ�֮����Լ̳�
 * 5) �����ʵ�ֶ���ӿ�, ʵ�ֶ�̳й�ϵ
 * 
 * 
 */
public class Demo06 {
	public static void main(String[] args) {
		Cat tom = new Cat();
		//Hunter hunter = new Hunter();//�������,���ܴ����ӿ�ʵ��
		Hunter hunter = tom;
		Runner r = tom;
		r.run();
		hunter.hunt();
		//r.hunt();//�����, r������Runner��û�ж���hunt()����
	}
}
//implements ʵ��, ʵ�ֽӿ�Ҫʵ��ȫ���ĳ��󷽷�
// èʵ��������, è��һ������, Ҳ���ܹ��ܵ�
class Cat implements Hunter, Runner{
	public int getSpeed() {
		return DEFAULT_SPEED;
	}
	public void hunt() {
		System.out.println("�ú���");
	}
	public void run() {
		System.out.println("��è��");
	}
}
/** �����ܵ� */
interface Runner{
	//�ӿ��е�����,ֻ���ǳ���!
	/*public static final*/ int DEFAULT_SPEED = 100;
	//�ӿ��������ķ���, ֻ���ǳ��󷽷�
	/*public abstract */ int getSpeed();//��ȡ�ٶ�
	void run();//��
}
/** ���� �ǿ����ܵ� */
interface Hunter extends Runner{
	void hunt();//����
}














