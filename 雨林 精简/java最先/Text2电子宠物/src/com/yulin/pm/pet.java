package com.yulin.pm;

import java.util.*;

public class pet {

	String name;
	int age;
	int ���� = -100;
	int level;
	int ���� = 10;
	int ��� = 10;
	int ���� = 10;
	int ���� = 10;

	// ϴ�裻���ټ���������࣬��ˣ�������齫�����ͼ�����������������������
	public pet(String name) {// �����ʼ�� ����������ָ���
		this.name = name;
		// age=0;
		System.out.println("��̰����");
		�ɳ�();

	}

	private void �ɳ�() {
		new Timer().schedule(new TimerTask() {
			@Override
			public void run() {
				���� += 10;

				if (���� >= 100) {
					age += 1;
					���� = 0;
				}
				���� -= 1;
				if (���� <= 0) {
					System.out.println("�±��Ӳ�����");
					System.out.print("game over");
					System.exit(0);
				}
				��� -= 10;
				if (��� == 0) {
					System.out.print("��Ҫϴ��");
				}

			}
		}, 3000, 1000);
	}

	public void ����() {
		System.out.println("����" + name);
		System.out.println("����" + age);
		System.out.println("����" + ����);
		System.out.println("���" + ���);
		System.out.println("����" + ����);
		System.out.println("����" + ����);
	}

	public void ϴ��() {
		��� += 20;
		���� -= 800;
		if (��� > 100) {
			��� = 100;

			System.out.print("ϴ��ȥ");

		}
	}

	public void ����() {
		System.out.print("�����Ҵ�");
	}

	public void ��ˣ() {
		���� += 20;
		��� -= 2000;
	}

	public void ιʳ() {
		���� += 30;//
		if (���� >= 100) {
			���� = 100;
			System.out.print(name + "��ι�ͷ���");
		} else {
			System.out.print(name + "����");
		}

	}

}