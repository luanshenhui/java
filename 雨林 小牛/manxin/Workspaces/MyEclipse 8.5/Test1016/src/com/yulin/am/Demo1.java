package com.yulin.am;

public class Demo1 {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		Dog dog=new Dog();//���Զ��幹�캯����ϵͳ�ṩ�Ĺ��캯����Ч
		// new Dog().name="����"; Dog��privateҪȥ��
		//new Dog().setName("����");
		System.out.println(dog.getName());
		dog.setName("����");
		dog.getName();
		System.out.println(dog.getName());
		dog.jiao();
		dog.eat();
	}

}
class Dog{
	//�Զ��幹�캯��
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
	//���Ժ���Ϊ��ȫ�ֱ����ͷ���
	private String name;
	private int age;
	private char sex;
	
	//��Ϊ
	public void jiao(){
		System.out.println("������~��");
	}
	public void eat(){
		System.out.println("��~��");
	}
	public String getName(){
		return name;
	}
	public void setName(String name){
		this.name=name;
	}
}
