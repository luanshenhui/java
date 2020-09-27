package day06;
/**
 * 模板模式
 * @author Administrator
 *
 */
public abstract class Person {
	/**
	 * 打招呼，自我介绍
	 */
	public void sayHello(){
		//相同的部分定义在这里
		System.out.println("大家好!");
		
		//细节的不同延迟到子类去实现
		System.out.println(getInfo());
		
		System.out.println("再见!");
	}
	
	public abstract String getInfo();
}

//学生
class Student extends Person{

	@Override
	public String getInfo() {
		return "我是一名学生，我上了12年小学!";
	}
	
}

class Teacher extends Person{
	@Override
	public String getInfo() {
		
		return "我是一名老师，我也不知道我会什么！";
	}
	
}


