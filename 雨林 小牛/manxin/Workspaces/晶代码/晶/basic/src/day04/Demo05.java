package day04;

import java.util.Scanner;

/**
 * 学生成绩管理
 * 
 * 数据模型设计
 *   names = { "Tom", "Jerry", "Andy", "John" }
 *   score = {  85  ,      67,    66,     98  }
 *              0          1       2       3
 * 算法设计，业务功能实现
 * 1 成绩输入  
 *   迭代显示每个人名，从控制台读取数据填充到对应的分数数组
 * 2 成绩列表, 并计算平均成绩
 *   迭代每个人名，并且显示对应的成绩，统计总分
 *   最后计算显示平均分。
 * 3 查询 某人的成绩
 *   等待输入查询人名，
 *   根据人名跌超找 人名，如果找到就显示人名和对应的成绩。
 */
public class Demo05 {
	public static void main(String[] args) {
		//数组的类型不是仅限于基本数据类型 引用类型同样可以
		String[] names = {"Tom","Jerry","Andy","John"};
		int[] score = new int[names.length];
		//处理控制台命令
		Scanner in = new Scanner(System.in);
		System.out.println("\t欢迎使用成绩管理");
		while(true){
			System.out.print(
					"1.成绩录入  2.成绩单  3.查询  0.离开, 选择:");
			String cmd = in.nextLine();//从控制台读取一行字符串
			//比较字符串必须使用equals()方法！
			//最后 是 字符串字面量与对象比较
			if("0".equals(cmd)){
				System.out.println("亲，再见了(T_T)!"); break;
			}else if("1".equals(cmd)){//cmd command 命令
				//输入
				System.out.println("开始输入成绩");
				for(int i=0; i<names.length; i++){
					String name = names[i];//name 代表每个人名
					System.out.print((i+1)+" 输入 "+name+" 的成绩：");
					String str = in.nextLine();//"95"
					//parseInt 将10进制的字符串转换为整数
					score[i]=Integer.parseInt(str);//"95" -> 95(int)
				}
			}else if("2".equals(cmd)){
				//成绩单
				int sum = 0;
				for(int i=0; i<names.length; i++){
					String name = names[i];
					System.out.println(
							(i+1) + "." + name +"的成绩:"+score[i]);
					sum += score[i];
				}
				System.out.println("平均成绩："+(sum/names.length));
			}else if("3".equals(cmd)){
				// 3.查询
				System.out.print("输入查询人名：");
				String name = in.nextLine();
				for(int i=0; i<names.length; i++){
					if(name.equals(names[i])){
						System.out.println(
								(i+1) + "." + name +"的成绩:"+score[i]);
						break;
					}
				}
			}else{
				System.out.println("命令错啦!");
			}
		}
	}
}










