package com.yulin.exam;
import java.io.*;
/**
 * ������
 * ���ԣ���š���ɡ�����
 * ���󷽷�����ʾ��������ʾ���⣻�ж϶Դ����ص÷�
 */
public abstract class Question {
	private int ���;
	private String ���;
	private int ����;
	
	public int get���() {
		return ���;
	}

	public void set���(int ���) {
		this.��� = ���;
	}

	public String get���() {
		return ���;
	}

	public void set���(String ���) {
		this.��� = ���;
	}

	public int get����() {
		return ����;
	}

	public void set����(int ����) {
		this.���� = ����;
	}
	
	public Question(){}
	
	public Question(String ���, int ����){ 
		super();
		this.��� = ���;
		this.���� = ����;
	}
	
	public abstract void ��ʾ();
	
	public abstract int �ж�(String �û���);
	
}
