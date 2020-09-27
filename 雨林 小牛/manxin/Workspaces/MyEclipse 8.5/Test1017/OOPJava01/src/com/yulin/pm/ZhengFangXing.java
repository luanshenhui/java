package com.yulin.pm;
import com.yulin.am.*;

public class ZhengFangXing extends SiBianXing{

	/**
	 * 面向对象 继承
	 */
	
	public ZhengFangXing(){
		System.out.println("我是子类，正方形");
	}
	
	public ZhengFangXing(int i){
		super(i);	//指向父类的同名方法或构造方法
		System.out.println("我是子类，正方形,参数i");
	}

	public static void main(String[] args) {
		// TODO Auto-generated method stub]
		ZhengFangXing zfx = new ZhengFangXing();
		ZhengFangXing zfx1 = new ZhengFangXing(5);
		
		/*zfx.getW();
		zfx.mj(5);
		zfx.mj(3, 4);
		zfx.setW(0);*/
		

	}

}
