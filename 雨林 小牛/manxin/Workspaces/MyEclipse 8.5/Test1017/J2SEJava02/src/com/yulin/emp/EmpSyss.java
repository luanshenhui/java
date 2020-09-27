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
		System.out.println("**********欢迎试用员工信息录入系统***********");
		Scanner scan = new Scanner(System.in);
		while(true){
			System.out.println("请选择您所要的操作：");
			System.out.println("1.添加员工信息");
			System.out.println("2.删除员工信息");
			System.out.println("3.查询员工信息");
			System.out.println("4.修改员工信息");
			System.out.println("5.退出系统");
			int in = scan.nextInt();
			switch(in){
			case 1 : add(); break;
			case 2 : del(); break;
			case 3 : que(); break;
			case 4 : upd(); break;
			case 5 : System.out.println("谢谢使用！"); System.exit(0);
			default : System.out.println("操作有误！");
			}

		}
	}

	
	private static ArrayList<Emp> list = new ArrayList<Emp>();
	
	private static void add() {
		// 添加员工信息,员工编号自动生成，1000 + 元素在集合中的位置
		// 薪水只给基本工资	2500
		// 入职时间自动生成
		int empId = 1000 + list.size() + 1;
		int salary = 2500;
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy年MM月dd日  :: hh时mm分ss秒");
		String hireDate = sdf.format(new Date());
		System.out.println("请输入 员工姓名:");
		Scanner scan = new Scanner(System.in);
		String name = scan.next();
		System.out.println("请输入 员工年龄:");
		int age = scan.nextInt();
		Emp e = new Emp(empId, name, salary, age, hireDate);
		list.add(e);

	}

	private static void del() {
		// 删除员工信息
		// 输入员工的ID和姓名进行删除，需要考虑到后续员工的ID编号
		Scanner scan = new Scanner(System.in);
		System.out.println("请输入要删除的员工编号：");
		int empId = scan.nextInt() + 1000;
		System.out.println("员工编号" + empId);
		System.out.println("请输入要删除的员工姓名：");
		String name = scan.next();
		Emp e = new Emp();
		e.setEmpId(empId);
		e.setName(name);
		int index = list.indexOf(e);
		System.out.println("删除前" + list.get(index));
		list.set(index, null);
		System.out.println("删除后" + list.get(index));
	}
	
	private static void que() {
		// 查询员工信息
		// 输入员工的ID和姓名进行查询，显示员工的所有信息
		Scanner scan = new Scanner(System.in);
		System.out.println("请输入要查询的员工编号：");
		int empId = scan.nextInt() + 1000;
		System.out.println("请输出要查询的员工姓名：");
		String name = scan.next();
		Emp e = new Emp();
		e.setEmpId(empId);
		e.setName(name);
		int index = list.indexOf(e);
		e = list.get(index);
		System.out.println("员工编号：" + e.getEmpId());
		System.out.println("员工姓名：" + e.getName());
		System.out.println("员工年龄：" + e.getAge());
		System.out.println("员工工资：" + e.getSalary());
		System.out.println("员工入职时间：" + e.getHireDate());
		System.out.println("******************************************");
	}
	
	private static void upd() {
		// 修改员工信息
		// 先删除，再插入
		// 通过员工的ID和姓名找到员工
		// 选择更改其薪资和部门
		// 更改完成之后，删除原来的信息，再将更改之后的对象插入原来的位置
		Scanner scan = new Scanner(System.in);
		System.out.println("请输入要修改的员工编号：");
		int empId = scan.nextInt();
		System.out.println("请输入要修改的员工姓名：");
		String name = scan.next();
		Emp e = new Emp();
		e.setEmpId(empId);
		e.setName(name);
		int index = list.indexOf(e);
		System.out.println("修改工资：");
		list.get(index).setSalary(scan.nextInt());
		System.out.println("修改部门：");
		list.get(index).setDeptId(scan.nextInt());
		System.out.println("修改成功！");
		System.out.println("******************************************");
		System.out.println("员工编号：" + e.getEmpId());
		System.out.println("员工姓名：" + e.getName());
		System.out.println("员工年龄：" + e.getAge());
		System.out.println("员工工资：" + e.getSalary());
		System.out.println("员工入职时间：" + e.getHireDate());
		System.out.println("******************************************");
	}

}
