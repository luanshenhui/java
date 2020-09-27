package com.yulin.am;

public class Demo1 {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		Dog dog=new Dog();//当自定义构造函数后，系统提供的构造函数无效
		// new Dog().name="旺财"; Dog里private要去掉
		//new Dog().setName("旺财");
		System.out.println(dog.getName());
		dog.setName("旺财");
		dog.getName();
		System.out.println(dog.getName());
		dog.jiao();
		dog.eat();
	}

}
class Dog{
	//自定义构造函数
	/*public Dog(String name,int age,char sex){
		this.name=name;
		this.age=age;
		this.sex=sex;
	}*/
	
	public int getAge() {
		return age;
	}
	public void setAge(int age) {
		this.age = age;
	}
	public char getSex() {
		return sex;
	}
	public void setSex(char sex) {
		this.sex = sex;
	}
	//属性和行为：全局变量和方法
	private String name;
	private int age;
	private char sex;
	
	//行为
	public void jiao(){
		System.out.println("汪汪汪~！");
	}
	public void eat(){
		System.out.println("吃~！");
	}
	public String getName(){
		return name;
	}
	public void setName(String name){
		this.name=name;
	}
}
