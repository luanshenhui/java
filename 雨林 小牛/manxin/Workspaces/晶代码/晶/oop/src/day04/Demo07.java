package day04;
/**
 * final 的实例变量，初始化以后不能再改
 */
public class Demo07 {
	public static void main(String[] args) {
		Dog wangcai = new Dog(1, 4);
		Dog wangwang = new Dog(2, 3);
		System.out.println(Dog.count+","+
				wangcai.id+","+wangwang.id);
		//wangcai.id = 6;//编译错误
		wangwang.age = 8;
	}
}
class Dog{
	final int id;//编号，初始化以后不能改
	int age;//可以改
	static int count;//狗的数量，只能有一份变量，进行统计
	public Dog(int id, int age) {
		this.id = id;	this.age = age;
		count++;
	}
}
