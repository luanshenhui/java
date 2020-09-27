package com.yulin.exam;

import java.util.Arrays;

/**
 *  ���ࣺ��ѡ��
 *		���ԣ���ȷ��
 *		�������ж���ȷ
 */

public class MultipleChoice extends Choice{
	private String zhengque;
	
	public MultipleChoice(int tihao,String tigan,String[] options,int score,String zhengque){
		super(tihao,tigan,options,score);
		this.zhengque=zhengque;
	}
	
	//�ж���ȷ
	@Override
	public boolean panDuan(String yonghu){
		char[] cs=new char[yonghu.length()];	//����ַ���
		for(int i=0;i<yonghu.length();i++){
			cs[i]=yonghu.charAt(i);
		}
		Arrays.sort(cs);	//��������
		yonghu = new String(cs);	//��װ���ַ���
		if(zhengque.equals(yonghu.toLowerCase()) || zhengque.equals(yonghu.toUpperCase())){
			return true;
		}else{
			return false;
		}
	}

}
