package com.yulin.pm;
import com.yulin.am.*;

public class ZhengFangXing extends SiBianXing{

	/**
	 * ������� �̳�
	 */
	
	public ZhengFangXing(){
		System.out.println("�������࣬������");
	}
	
	public ZhengFangXing(int i){
		super(i);	//ָ�����ͬ���������췽��
		System.out.println("�������࣬������,����i");
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
