package com.yulin.am;

public class Demo1 {
	public static void main(String[] args){
//new Dog().setName("����");
	Dog d = new Dog("����",1,'x');  
	d.setName("��");
	
	System.out.println(d.getName());

	d.��();
	d.��();
}}
class Dog{
	private String name;
	private int age;
	private char sex;
	
	public Dog(String name,int age, char sex){
		this.name = name;
		this.age = age;
		this.sex = sex;
		//System.out.println("����",1,'x');
	}
	
	public void ��(){
		System.out.println("wang");
	
	}
	public void ��(){
		System.out.println("Ʊ��");
		
	}
	/*public int getAge() {
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
	public void setName(String name) {
		this.name = name;
	}*/
	public String getName(){
		return name;//�������
	}
public void setName(String name){

	this.name= name;
}
}