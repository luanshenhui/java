package day04;
/**
 * final ��ʵ����������ʼ���Ժ����ٸ�
 */
public class Demo07 {
	public static void main(String[] args) {
		Dog wangcai = new Dog(1, 4);
		Dog wangwang = new Dog(2, 3);
		System.out.println(Dog.count+","+
				wangcai.id+","+wangwang.id);
		//wangcai.id = 6;//�������
		wangwang.age = 8;
	}
}
class Dog{
	final int id;//��ţ���ʼ���Ժ��ܸ�
	int age;//���Ը�
	static int count;//����������ֻ����һ�ݱ���������ͳ��
	public Dog(int id, int age) {
		this.id = id;	this.age = age;
		count++;
	}
}
