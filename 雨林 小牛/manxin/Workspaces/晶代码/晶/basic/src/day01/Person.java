package day01;
/*
 * 我在很多类都使用这个session这个对象
 * 所以我使用继承这种东西来做  也就是
 * 在很多不同的类都会继承这个类  
 * 那么继承这个类会有一个session给我
 * 然后你思考一下  在session这个类里面做了什么？
 */
public class Person {
	//一个类的对象可以当做另一个类的成员变量
	Person a1 = new Person();
	//son a1 = new son();
	public Person getA(){
		return a1;
	}
	public void cc(){
		a1.cc();
	}
}
class son extends Person{
	public void test(){
		a1.cc();
		a1.getA();
	}
}
class a extends Person{ 
	public void d(){
		a1.cc();
		}
	}
