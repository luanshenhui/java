package day04;
/**
 * ��̬����ֻ��һ�ݣ�һ��ʹ���������� 
 */
public class Demo01 {
	public static void main(String[] args) {
		Cat tom = new Cat(5);
		Cat kitty = new Cat(4);
		System.out.println(tom.age + 
				","+kitty.age+","+Cat.numOfCats);
		
	}
}
class Cat{
	int age;
	static int numOfCats;
	public Cat(int age) {
		this.age = age;
		Cat.numOfCats++;//Cat.����ʡ��
	}
}