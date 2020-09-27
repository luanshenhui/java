package com.yulin.exam;

import java.util.Arrays;

/**
 *  子类：多选题
 *		属性：正确答案
 *		方法：判断正确
 */

public class MultipleChoice extends Choice{
	private String zhengque;
	
	public MultipleChoice(int tihao,String tigan,String[] options,int score,String zhengque){
		super(tihao,tigan,options,score);
		this.zhengque=zhengque;
	}
	
	//判断正确
	@Override
	public boolean panDuan(String yonghu){
		char[] cs=new char[yonghu.length()];	//拆分字符串
		for(int i=0;i<yonghu.length();i++){
			cs[i]=yonghu.charAt(i);
		}
		Arrays.sort(cs);	//数组排序
		yonghu = new String(cs);	//组装回字符串
		if(zhengque.equals(yonghu.toLowerCase()) || zhengque.equals(yonghu.toUpperCase())){
			return true;
		}else{
			return false;
		}
	}

}
