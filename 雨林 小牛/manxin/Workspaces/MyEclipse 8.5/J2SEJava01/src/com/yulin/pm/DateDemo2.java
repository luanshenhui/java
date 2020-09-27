package com.yulin.pm;
import java.util.*;
import java.text.*;

public class DateDemo2 {

	/**
	 * SimpleDateFormat:
	 * ��ϰ��Ա����Ϣ¼��ϵͳ��
	 * ********��ӭʹ��Ա����Ϣ¼��ϵͳ********
	 * 1.¼��Ա����Ϣ
	 * 		--->������Ա������
	 * 			------->Monty
	 * 2.��ѯ����Ա������ְ��Ϣ
	 * 		--->������Monty
	 * 			��ְʱ�䣺2014-11-03  :�� 17:21��ְ
	 * 3.�˳�ϵͳ
	 * 
	 * ����Ϣ��StringBufferƴ�Ӻ󱣴����ַ�������
	 */
	public static void main(String[] args) {
		DateDemo2 dd2 = new DateDemo2();
		dd2.show();
	}

	
	public void show(){
		System.out.println("**********��ӭ����Ա����Ϣ¼��ϵͳ***********");
		Scanner scan = new Scanner(System.in);
		String[] emps = new String[0];
		String timeFomat = "yyyy-MM-dd E";	//�Զ����ʱ���ʽ
		SimpleDateFormat sdf = new SimpleDateFormat(timeFomat);	//�������������
		Date date = new Date();
		while(true){
			System.out.println("��ѡ������Ҫ�Ĳ�����");
			System.out.println("1.¼��Ա����Ϣ");
			System.out.println("2.��ѯ����Ա����Ϣ");
			System.out.println("3.�˳�ϵͳ");
			int in = scan.nextInt();
			if(in == 1){
				System.out.println("������ Ա������:");
				String name = scan.next();
				String time = sdf.format(date);	//��ʱ��ת�����ַ���
				emps = Arrays.copyOf(emps, emps.length + 1);	//����
				emps[emps.length - 1] = name + "@" + time;	//ƴ�ӱ���
				System.out.println("����ɹ���");
			}else if(in == 2){
				for(String s : emps){	//forEachѭ��
					String[] ss = s.split("@");
					System.out.println("Ա������:" + ss[0]);
					System.out.println("��ְʱ��" + ss[1]);
					String time1 = ss[1].toString();
	//				String time2 = time2.compareTo(time1);
					System.out.println("********************************");
					System.out.println("******************");
				}
			}else if(in == 3){
				System.err.println("***************�˳�ϵͳ***************");
				System.err.println("��ӭ�´�ʹ��");
				System.exit(0);
			}
		}
	}	
}
