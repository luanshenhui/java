package com.c;

public class A {
	private static A a;

	private A() {

	}

	// ���ַ����̲߳���ȫ����Ҫ���synchronized�ؼ���,���Ա�֤�̰߳�ȫ
	// ͬ������(synchronized���εķ���)�����Ӿ��Ƿ�ͬ������
	/*
	 * ��java�У�ÿ��������һ���� ���������ͬ���������߳��ڽ��뷽��֮ǰ���鵱ǰ��Ķ���ʱ�񱻼����������������Ⱥ����û������ɽ��롣
	 * ���߳̽���ͬ����������������м���������������������������
	 */
	public/* synchronized */static A getA() {
		String s = "���";// ��㶨һ������
		synchronized (s) {// �Զ������
			if (a == null) {
				a = new A();
			}
		}
		return a;
	}
}
