package com.b;

public class Member {

	private String name;
	private int age;
	
	/*
	 * ����һ��
	 * ��set�����Զ������͵Ķ��� ��ʵ�ֵķ���
	 * 1����дObject Hashcode ����
	 * 2����дObject equals����
	 * 
	 */

	public Member(String name, int age) {
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
	public int hashCode() {
		// TODO Auto-generated method stub
		return 1;
	}
	
	

	@Override
	public boolean equals(Object obj) {
		// TODO Auto-generated method stub
		Member m=(Member)obj;
		boolean boo=(this.getName().equals(m.getName())&&this.getAge()==m.getAge());
		return boo;
	}

	@Override
	public String toString() {
		return "Member [age=" + age + ", name=" + name + "]";
	}

}
