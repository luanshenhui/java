package com.yulin.exam;
import java.io.*;
/**
 * ����(ѡ����)
 * ���ԣ�ѡ���ȷ��
 * ���������Ƿ�������ʾ���ж϶Դ�
 */
public class SelectQuestion extends Question{
	
	private String ��ȷ��;
	private String[] ѡ��;
	
	public String get��ȷ��() {
		return ��ȷ��;
	}
	public void set��ȷ��(String ��ȷ��) {
		this.��ȷ�� = ��ȷ��;
	}
	public String[] getѡ��() {
		return ѡ��;
	}
	public void setѡ��(String[] ѡ��) {
		this.ѡ�� = ѡ��;
	}
	
	public SelectQuestion(){}
	
	public SelectQuestion(String ���, String[] ѡ��, String ��ȷ��, int ����){
		super(���,����);
		this.ѡ�� = ѡ��;
		this.��ȷ�� = ��ȷ��;
	}
	
	@Override 
	public void ��ʾ(){
		System.out.println(get���() + "." + get���());
		System.out.println("\t+A." + getѡ��()[0]);
		System.out.println("\t+B." + getѡ��()[1]);
		System.out.println("\t+C." + getѡ��()[2]);
		System.out.println("\t+D." + getѡ��()[3]);
	}
	
	@Override 
	public int �ж�(String �û���){
		if(��ȷ��.equals(�û���)){
			return get����();
		}
		return 0;
	}
}
