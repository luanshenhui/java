package day03.pm;
/**
 * instanceof �����
 *  �Ǽ�����õĶ�������ͼ����� 
 *  instance ʵ��  of ��
 * 
 * t instance of I : ��� t���õĶ����Ƿ���"I��ʵ��" 
 */
public class Demo10 {
	public static void main(String[] args) {
		Tetromino t = new T();
		printType(t);
		T tx  = (T)t;// ��ɹ���
		//I i = (I)t;//����������쳣, ����ȫ������ת��
		//instanceof �����ʹ�÷�ʽ, ����(��ȫ��)����ת��
		if(t instanceof I){
			I i = (I)t;// ʹ��instanceof ���������Ͱ�ȫ��ת��
		}
	}
	public static void printType(Tetromino t){
		//t instanceof I ���t���õĶ����Ƿ��� I ���͵�
		//�����I���͵ľͷ���true, ���򷵻�false
		if(t instanceof I){
			System.out.println("I �ͷ���");
		}
		if(t instanceof T){
			System.out.println("T �ͷ���");
		}
	}
}
class Tetromino{}
class T extends Tetromino{}
class I extends Tetromino{}

