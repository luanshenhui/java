package com.yulin.pm;

public class InterfaceDemo {
	public static void main(String[] args){
//		˾��  man = new Man();
//		��ʦ man2 = new Man();
//		ҽ��  man3 = new Man();
		ȫ�� q = new Man();
		Aoo aoo = new Aoo();
		aoo.zhaopin(q);
//		aoo.zhaopin(man1);
//		aoo.zhaopin(man2);
//		aoo.zhaopin(man3);
	}
}

interface ˾��{
	public void ����();
}

interface ��ʦ{
	public void ����();
}

interface ҽ��{
	public void ����();
}

abstract class ȫ�� implements ˾��,��ʦ,ҽ��{	//������
	@Override
	public void ����() {
		// TODO Auto-generated method stub
		System.out.println("�һῪ��~");
	}

	@Override
	public void ����() {
		// TODO Auto-generated method stub
		System.out.println("�һὲ��~");
	}

	@Override
	public void ����() {
		// TODO Auto-generated method stub
		System.out.println("�һ����~");
	}
}

class Man extends ȫ��{
	public void ����(){
		System.out.println("�һῪ�ܳ�~");
	}
}


class Aoo{
	public void zhaopin(ȫ�� s){
		s.����();
		s.����();
		s.����();
	}
	
}