package com.yulin.exam;

/**
 * 子类：单选题
 *		属性：正确答案
 *		方法：判断正确
 */

public class SingleChoice extends Choice{
	
	private String zhengque;	//正确答案
	
	public SingleChoice(int tihao,String tigan,String[] options,int score,String zhengque){
		super(tihao,tigan,options,score);	//指向父类有参数的构造方法
		this.zhengque=zhengque;
	}
	
	//判断正确
	@Override
	public boolean panDuan(String yonghu){	//yonghu:用户答案
		if(zhengque.equals(yonghu.toLowerCase()) || zhengque.equals(yonghu.toUpperCase())){
			return true;
		}else{
			return false;
		}
	}

}
