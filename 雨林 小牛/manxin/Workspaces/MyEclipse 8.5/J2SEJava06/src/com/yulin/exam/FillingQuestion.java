package com.yulin.exam;
import java.io.*;
/**
 * ����(�����)
 * ���ԣ���ȷ��
 * ���������Ƿ�������ʾ���ж�
 */
public class FillingQuestion extends Question{
	private String ��ȷ��;
	
	public FillingQuestion(){}
	
	public FillingQuestion(String ���, String ��ȷ��, int ����){
		super(���,����);
		this.��ȷ�� = ��ȷ��;
	}
	
	public String get��ȷ��() {
		return ��ȷ��;
	}
	
	public void set��ȷ��(String ��ȷ��) {
		this.��ȷ�� = ��ȷ��;
	}

	@Override
	public void ��ʾ(){
		System.out.println(get���() + "." + get���());
	}
	
	@Override 
	public int �ж�(String �û���){
		if(��ȷ��.equals(�û���)){
			return get����();
		}else{
			return 0;
		}
	}

}