package com.yulin.exam;

public class Choice {
	
	/**
	 * ģ�⿼��ϵͳ
	 *   ���ࣺ����
	 *		���ԣ���ɡ�ѡ�����
	 *		��������ʾ
	 */
	
	private int tihao;	//���
	private String tigan;	//���
	private String[] options = new String[4];	//ѡ�� ABCD
	private int score;	//����
	
	//��ʾ
	public void show(){
		System.out.println(tihao+"."+tigan);
		System.out.println("   "+options[0]);
		System.out.println("   "+options[1]);
		System.out.println("   "+options[2]);
		System.out.println("   "+options[3]);	
	}
	
	//���췽��
	public Choice(){}//�޲ι���,
	
	//���ع��췽��,�вι��췽��
	public Choice(int tihao,String tigan,String[] options,int score){
		this.tihao = tihao;
		this.tigan = tigan;
		this.options = options;
		this.score = score;
	}
	
	//��õ÷�
	public int getScore(){
		return this.score;
	}

	public boolean panDuan(String string) {
		// TODO Auto-generated method stub
		return false;
	}

}
