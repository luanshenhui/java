package day01;
/**
 * 抛出异常
 * @author Administrator
 *
 */
public class ThrowExceptionDemo {
	public static void main(String[] args) {
		try{
				Person person = new Person();
				person.setAge(10000);//不符合人类年龄，但语法没错
				System.out.println(person);
		}catch(Exception e){
				/**
				 * 异常定义了两个常用的方法
				 * void printStackTrace()
				 * 作用:输出错误堆栈信息,用于帮助我们得知错误出现
				 *      的位置
				 * 
				 * String getMessage()
				 * 作用:获取错误信息，通常是得知错误原因
				 */
			e.printStackTrace();
 		}
		
	}
}
class Person{
	private int age;
	
	public void setAge(int age){
		if(age<0||age>100){
			//创建运行时异常并抛出，参数为错误信息
			throw new RuntimeException("年龄不合法");
		}
		this.age = age;
	}
	
	public String toString(){
		return "我的年龄是"+age+"岁";
	}
}


