package day03;
import java.util.Scanner;

/**
 * 个人所得税计算 
 * 
 * if(){
 * 
 * }else if(){
 * 
 * }
 * 
 */
public class Demo02 {
	public static void main(String[] args) {
		Scanner in = new Scanner(System.in);
		double salary; //薪水，税前薪资
		System.out.print("输入税前薪资：");
		salary = in.nextDouble();
		double income; //税后所得
		double tax; //税
		double taxIncome; //应税薪资
		taxIncome = salary - 3500;
		//计算税额, 累进计算
		if(taxIncome<=0){	
			tax = 0;
		}else if(taxIncome<=1500){
			tax = taxIncome * (3.0/100);
		}else if(taxIncome<=4500){
			tax = taxIncome * (10.0/100) - 105;
		}else if(taxIncome<=9000){
			tax = taxIncome * (20.0/100) - 555;
		}else if(taxIncome<=35000){
			tax = taxIncome * (25.0/100) - 1005;
		}else if(taxIncome<=55000){
			tax = taxIncome * (30.0/100) - 2755;
		}else if(taxIncome<=80000){
			tax = taxIncome * (35.0/100) - 5505;
		}else {
			tax = taxIncome * (45.0/100) - 13505;
		}
		//计算收入
		income = salary - tax;
		System.out.println("税后所得:"+income +" 税："+tax);
	}
}
