package day03;
import java.util.Scanner;

/**
 * ��������˰���� 
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
		double salary; //нˮ��˰ǰн��
		System.out.print("����˰ǰн�ʣ�");
		salary = in.nextDouble();
		double income; //˰������
		double tax; //˰
		double taxIncome; //Ӧ˰н��
		taxIncome = salary - 3500;
		//����˰��, �۽�����
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
		//��������
		income = salary - tax;
		System.out.println("˰������:"+income +" ˰��"+tax);
	}
}
