
public class Person {
	public Person(){
		this("");
	}
	public Person(String name){
		this(name);
	}
	public Person(String name,int age){
		this(name,age);
	}
	public Person(String name,int age,String sex){
		this(name,age,sex);
	}
	public Person(String name,int age,String sex,int number){
		this.name=name;
		this.age=age;
		this.sex=sex;
		this.number=number;
	}
}
