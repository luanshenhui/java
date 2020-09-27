package Test;

public class Person {

	
	
	private String name;
	
	private int age;
	
	public Person()
	{
		this("");
	}
	
	public Person(String name)
	{
		this(name,0);
	}
	public Person(String name,int age)
	{
		this.name=name;
		this.age=age;
		
	}
	
	
	public String getName() {
		return name;
	}


	public void setName(String name) {
		this.name = name;
	}

	public int getAge() {
		return age;
	}

	public void setAge(int age) {
		this.age = age;
	}





	@Override
	public String toString() {
		
		return this.name+this.age;
	}

	public static void main(String[] args) {
		
   Person person1=new Person();
   person1.setName("张山");
   person1.setAge(30);
   System.out.println(person1);
   System.out.println(person1.toString());
   
   Person person2=new Person("李四");
   person2.setAge(40);
   System.out.println(person2);
   
   
   Person person3=new Person("王五",59);
   System.out.println(person3);
		
		
	}

}
