package com.yulin.am;

public class Demo1 {
	public static void main(String[] args){
//new Dog().setName("Íú²Æ");
	Dog d = new Dog("À´¸£",1,'x');  
	d.setName("Íú");
	
	System.out.println(d.getName());

	d.³Ô();
	d.½Ð();
}}
class Dog{
	private String name;
	private int age;
	private char sex;
	
	public Dog(String name,int age, char sex){
		this.name = name;
		this.age = age;
		this.sex = sex;
		//System.out.println("À´¸£",1,'x');
	}
	
	public void ½Ð(){
		System.out.println("wang");
	
	}
	public void ³Ô(){
		System.out.println("Æ±¼Ð");
		
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
		return name;//»ñµÃÃû×Ö
	}
public void setName(String name){

	this.name= name;
}
}