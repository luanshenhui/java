package com.yulin.emp;

import java.util.*;
import java.text.*;

public class EmpSyss extends Emp{

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		EmpSyss es = new EmpSyss();
		es.show();
	}
	
	public void show(){
		System.out.println("**********��ӭ����Ա����Ϣ¼��ϵͳ***********");
		Scanner scan = new Scanner(System.in);
		while(true){
			System.out.println("��ѡ������Ҫ�Ĳ�����");
			System.out.println("1.���Ա����Ϣ");
			System.out.println("2.ɾ��Ա����Ϣ");
			System.out.println("3.��ѯԱ����Ϣ");
			System.out.println("4.�޸�Ա����Ϣ");
			System.out.println("5.�˳�ϵͳ");
			int in = scan.nextInt();
			switch(in){
			case 1 : add(); break;
			case 2 : del(); break;
			case 3 : que(); break;
			case 4 : upd(); break;
			case 5 : System.out.println("ллʹ�ã�"); System.exit(0);
			default : System.out.println("��������");
			}

		}
	}

	
	private static ArrayList<Emp> list = new ArrayList<Emp>();
	
	private static void add() {
		// ���Ա����Ϣ,Ա������Զ����ɣ�1000 + Ԫ���ڼ����е�λ��
		// нˮֻ����������	2500
		// ��ְʱ���Զ�����
		int empId = 1000 + list.size() + 1;
		int salary = 2500;
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy��MM��dd��  :: hhʱmm��ss��");
		String hireDate = sdf.format(new Date());
		System.out.println("������ Ա������:");
		Scanner scan = new Scanner(System.in);
		String name = scan.next();
		System.out.println("������ Ա������:");
		int age = scan.nextInt();
		Emp e = new Emp(empId, name, salary, age, hireDate);
		list.add(e);

	}

	private static void del() {
		// ɾ��Ա����Ϣ
		// ����Ա����ID����������ɾ������Ҫ���ǵ�����Ա����ID���
		Scanner scan = new Scanner(System.in);
		System.out.println("������Ҫɾ����Ա����ţ�");
		int empId = scan.nextInt() + 1000;
		System.out.println("Ա�����" + empId);
		System.out.println("������Ҫɾ����Ա��������");
		String name = scan.next();
		Emp e = new Emp();
		e.setEmpId(empId);
		e.setName(name);
		int index = list.indexOf(e);
		System.out.println("ɾ��ǰ" + list.get(index));
		list.set(index, null);
		System.out.println("ɾ����" + list.get(index));
	}
	
	private static void que() {
		// ��ѯԱ����Ϣ
		// ����Ա����ID���������в�ѯ����ʾԱ����������Ϣ
		Scanner scan = new Scanner(System.in);
		System.out.println("������Ҫ��ѯ��Ա����ţ�");
		int empId = scan.nextInt() + 1000;
		System.out.println("�����Ҫ��ѯ��Ա��������");
		String name = scan.next();
		Emp e = new Emp();
		e.setEmpId(empId);
		e.setName(name);
		int index = list.indexOf(e);
		e = list.get(index);
		System.out.println("Ա����ţ�" + e.getEmpId());
		System.out.println("Ա��������" + e.getName());
		System.out.println("Ա�����䣺" + e.getAge());
		System.out.println("Ա�����ʣ�" + e.getSalary());
		System.out.println("Ա����ְʱ�䣺" + e.getHireDate());
		System.out.println("******************************************");
	}
	
	private static void upd() {
		// �޸�Ա����Ϣ
		// ��ɾ�����ٲ���
		// ͨ��Ա����ID�������ҵ�Ա��
		// ѡ�������н�ʺͲ���
		// �������֮��ɾ��ԭ������Ϣ���ٽ�����֮��Ķ������ԭ����λ��
		Scanner scan = new Scanner(System.in);
		System.out.println("������Ҫ�޸ĵ�Ա����ţ�");
		int empId = scan.nextInt();
		System.out.println("������Ҫ�޸ĵ�Ա��������");
		String name = scan.next();
		Emp e = new Emp();
		e.setEmpId(empId);
		e.setName(name);
		int index = list.indexOf(e);
		System.out.println("�޸Ĺ��ʣ�");
		list.get(index).setSalary(scan.nextInt());
		System.out.println("�޸Ĳ��ţ�");
		list.get(index).setDeptId(scan.nextInt());
		System.out.println("�޸ĳɹ���");
		System.out.println("******************************************");
		System.out.println("Ա����ţ�" + e.getEmpId());
		System.out.println("Ա��������" + e.getName());
		System.out.println("Ա�����䣺" + e.getAge());
		System.out.println("Ա�����ʣ�" + e.getSalary());
		System.out.println("Ա����ְʱ�䣺" + e.getHireDate());
		System.out.println("******************************************");
	}

}
