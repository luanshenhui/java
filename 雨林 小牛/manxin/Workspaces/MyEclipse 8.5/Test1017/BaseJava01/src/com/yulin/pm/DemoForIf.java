package com.yulin.pm;
import java.util.*;

public class DemoForIf{

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		
		//练习：随机出两个数中的一个-1和1
		/*Random rd = new Random();//创建一个随机数工具
		//int in=rd.nextInt(10)+1;//1-10
		int in=rd.nextInt(2)*2-1;
		System.out.println(in);*/
		
/*		int i=0;
		System.out.println(i++);
		System.out.println(i);
		i=0;
		System.out.println(++i);
		System.out.println(i);
		i=0;
		System.out.println(i++ + ++i);
		
		System.out.println("~~~~~~~~~华丽的分割线~~~~~~~~~");*/
		
		/**switch/case
		*练习：输入一个字符'a','b','c'或者'd',分别输出优秀，良好，中等和不合格
				如果输入其他字符，提示输入错误*/
		/*Scanner scan = new Scanner(System.in);
		System.out.println("请输入a,b,c或d");
		char ch=scan.next().charAt(0);//读入一个字符
		switch(ch){
			case 'a':System.out.println("优秀");
			break;
			case 'b':System.out.println("良好");
			break;
			case 'c':System.out.println("中等");
			break;
			case 'd':System.out.println("不合格");
			break;
			default:System.out.println("您的输入有误");
		}*/
		
		/**if else if 
		 * ~练习：输入一个分数，根据输入的分数返回结果
		 * 85~100：优秀 		70~84：良好		60~69：及格		0~59：不及格		>100或者<0:输入有误
		 * */
		/*Scanner scan = new Scanner(System.in);
		System.out.println("请输入分数：");
		int score=scan.nextInt();
		if(score>=85 && score<=100){
			System.out.println("优秀~");
		}else if(score>=70 && score<=84){
			System.out.println("良好~");
		}else if(score>=60 && score<=69){
			System.out.println("及格~");
		}else if(score>=0 && score<=59){
			System.out.println("不及格~");
		}else{
			System.out.println("输入有误~");
		}*/
		
		/**练习2：BMI身体肥胖质数计算器：输入身高和体重，返回BMI的值，以及身体状况
		 * BMI=身高(m)/体重(kg)的平方
		 * 男：0~20偏瘦；21~25：标准；26~30:超重；31~35：肥胖；35+：非常肥胖 
		 * 女：0~19偏瘦；20~24：标准；25~29:超重；30~34：肥胖；34+：非常肥胖 
		 * */
	/*	Scanner scanm = new Scanner(System.in);
		System.out.println("请输入您的身高：");
		double m=scanm.nextDouble();
		Scanner scankg = new Scanner(System.in);	
		System.out.println("请输入您的体重：");
		double kg=scankg.nextDouble();
		Scanner scanex = new Scanner(System.in);
		System.out.println("请输入您的性别：");
		char ch=scanex.next().charAt(0);
		double BMI;
		BMI=kg/(m*m);
		//BMI = (ch=='男')?BMI:BMI+1 //省略判断男女
		if(ch=='男'){
			if(BMI>0 && BMI<=20){
				System.out.println("偏瘦");
			}else if(BMI>=21 && BMI<=25){
				System.out.println("标准");
			}else if(BMI>=26 && BMI<=30){
				System.out.println("超重");
			}else if(BMI>=31 && BMI<=35){
				System.out.println("肥胖");
			}else{
				System.out.println("非常肥胖");
			}
		}else if(ch=='女'){
			if(BMI>0 && BMI<=19){
				System.out.println("偏瘦");
			}else if(BMI>=20 && BMI<=24){
				System.out.println("标准");
			}else if(BMI>=25 && BMI<=29){
				System.out.println("超重");
			}else if(BMI>=30 && BMI<=34){
				System.out.println("肥胖");
			}else{
				System.out.println("非常肥胖");
			}Well begun is half done
		}else{
			System.out.println("您的输入有误！");
		}*/
		
		/**条形码验证：把偶数序号的数相加求和，再乘3，再把奇数序号的数相加求和，再和偶数序号上的积求和，再用
		 * 10减去这个和的个位数，得出校验码 
		 * */
		Scanner scan = new Scanner(System.in);
		System.out.println("请输入条形码：");
		long txm=scan.nextLong();
		System.out.println("请输入校验码：");
		int xym=scan.nextInt();
		System.out.println("条形码："+txm);
		System.out.println("校验码："+xym);
		int a=0,b=0;
		for(int i=0;i<6;i++){
			a+=txm%10;
			txm/=10;
			System.out.println("a："+a);
			b+=txm%10;
			txm/=10;
		}
		a=a*3+b;
		a=10-a%10;
		System.out.println("您输入的校验码："+((a==xym)?"真的":"赝品"));
		

	}

}
