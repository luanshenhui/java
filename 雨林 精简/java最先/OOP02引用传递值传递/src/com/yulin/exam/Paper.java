package com.yulin.exam;

import java.util.Scanner;

public class Paper {
	private Choice[] ѡ����;
	private String[] �û���;

	public Paper() {

	}

	public Paper(Choice[] ѡ����) {
		this.ѡ���� = ѡ����;
		this.�û��� = new String[ѡ����.length];// �û��𰸵ĸ�������ѡ����ĸ���

	}

	public void show() {// ����ѭ����ʾѡ����
		for (int i = 0; i < ѡ����.length; i++) {
			ѡ����[i].��ʾ();
			�û���[i] = ����2();
		}

	}

	public void ����() {
		Scanner sc = new Scanner(System.in);
		for (int i = 0; i < �û���.length; i++) {
			�û���[i] = sc.next();
		}
	}

	public String ����2() {
		System.out.print("��Ĵ��ǣ�");
		Scanner sc = new Scanner(System.in);
		return sc.next();
		// �û���[i]=sc.next();
	}

	private int score = 0;

	public int ����() {// ����b

		for (int i = 0; i < ѡ����.length; i++) {
			if (ѡ����[i].�ж���ȷ(�û���[i])) {
				score += ѡ����[i].get�÷�();
			}
		}
		return score;
	}

	public void ��ʾ�÷�() {
		System.out.println("�����ĵ÷��ǣ�" + score);
	}
}

// ��ʾ������ѭ����ʾѡ����
// ���⣬����Scanner����û���
// �����ж��û�����ȷ���
// ��ʾ�÷֣�
