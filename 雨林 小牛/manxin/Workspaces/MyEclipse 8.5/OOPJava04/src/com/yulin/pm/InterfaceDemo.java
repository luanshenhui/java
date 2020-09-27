package com.yulin.pm;

public class InterfaceDemo {
	public static void main(String[] args){
//		司机  man = new Man();
//		老师 man2 = new Man();
//		医生  man3 = new Man();
		全能 q = new Man();
		Aoo aoo = new Aoo();
		aoo.zhaopin(q);
//		aoo.zhaopin(man1);
//		aoo.zhaopin(man2);
//		aoo.zhaopin(man3);
	}
}

interface 司机{
	public void 开车();
}

interface 老师{
	public void 讲课();
}

interface 医生{
	public void 打针();
}

abstract class 全能 implements 司机,老师,医生{	//抽象类
	@Override
	public void 开车() {
		// TODO Auto-generated method stub
		System.out.println("我会开车~");
	}

	@Override
	public void 讲课() {
		// TODO Auto-generated method stub
		System.out.println("我会讲课~");
	}

	@Override
	public void 打针() {
		// TODO Auto-generated method stub
		System.out.println("我会打针~");
	}
}

class Man extends 全能{
	public void 开车(){
		System.out.println("我会开跑车~");
	}
}


class Aoo{
	public void zhaopin(全能 s){
		s.开车();
		s.讲课();
		s.打针();
	}
	
}