package com.yulin.exam;

/**
 * ���ࣺ��ѡ��
 *		���ԣ���ȷ��
 *		�������ж���ȷ
 */

public class SingleChoice extends Choice{
	
	private String zhengque;	//��ȷ��
	
	public SingleChoice(int tihao,String tigan,String[] options,int score,String zhengque){
		super(tihao,tigan,options,score);	//ָ�����в����Ĺ��췽��
		this.zhengque=zhengque;
	}
	
	//�ж���ȷ
	@Override
	public boolean panDuan(String yonghu){	//yonghu:�û���
		if(zhengque.equals(yonghu.toLowerCase()) || zhengque.equals(yonghu.toUpperCase())){
			return true;
		}else{
			return false;
		}
	}

}
