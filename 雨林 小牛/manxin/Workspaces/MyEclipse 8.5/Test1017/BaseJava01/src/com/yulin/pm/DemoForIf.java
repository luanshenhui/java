package com.yulin.pm;
import java.util.*;

public class DemoForIf{

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		
		//��ϰ��������������е�һ��-1��1
		/*Random rd = new Random();//����һ�����������
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
		
		System.out.println("~~~~~~~~~�����ķָ���~~~~~~~~~");*/
		
		/**switch/case
		*��ϰ������һ���ַ�'a','b','c'����'d',�ֱ�������㣬���ã��еȺͲ��ϸ�
				������������ַ�����ʾ�������*/
		/*Scanner scan = new Scanner(System.in);
		System.out.println("������a,b,c��d");
		char ch=scan.next().charAt(0);//����һ���ַ�
		switch(ch){
			case 'a':System.out.println("����");
			break;
			case 'b':System.out.println("����");
			break;
			case 'c':System.out.println("�е�");
			break;
			case 'd':System.out.println("���ϸ�");
			break;
			default:System.out.println("������������");
		}*/
		
		/**if else if 
		 * ~��ϰ������һ����������������ķ������ؽ��
		 * 85~100������ 		70~84������		60~69������		0~59��������		>100����<0:��������
		 * */
		/*Scanner scan = new Scanner(System.in);
		System.out.println("�����������");
		int score=scan.nextInt();
		if(score>=85 && score<=100){
			System.out.println("����~");
		}else if(score>=70 && score<=84){
			System.out.println("����~");
		}else if(score>=60 && score<=69){
			System.out.println("����~");
		}else if(score>=0 && score<=59){
			System.out.println("������~");
		}else{
			System.out.println("��������~");
		}*/
		
		/**��ϰ2��BMI�������������������������ߺ����أ�����BMI��ֵ���Լ�����״��
		 * BMI=���(m)/����(kg)��ƽ��
		 * �У�0~20ƫ�ݣ�21~25����׼��26~30:���أ�31~35�����֣�35+���ǳ����� 
		 * Ů��0~19ƫ�ݣ�20~24����׼��25~29:���أ�30~34�����֣�34+���ǳ����� 
		 * */
	/*	Scanner scanm = new Scanner(System.in);
		System.out.println("������������ߣ�");
		double m=scanm.nextDouble();
		Scanner scankg = new Scanner(System.in);	
		System.out.println("�������������أ�");
		double kg=scankg.nextDouble();
		Scanner scanex = new Scanner(System.in);
		System.out.println("�����������Ա�");
		char ch=scanex.next().charAt(0);
		double BMI;
		BMI=kg/(m*m);
		//BMI = (ch=='��')?BMI:BMI+1 //ʡ���ж���Ů
		if(ch=='��'){
			if(BMI>0 && BMI<=20){
				System.out.println("ƫ��");
			}else if(BMI>=21 && BMI<=25){
				System.out.println("��׼");
			}else if(BMI>=26 && BMI<=30){
				System.out.println("����");
			}else if(BMI>=31 && BMI<=35){
				System.out.println("����");
			}else{
				System.out.println("�ǳ�����");
			}
		}else if(ch=='Ů'){
			if(BMI>0 && BMI<=19){
				System.out.println("ƫ��");
			}else if(BMI>=20 && BMI<=24){
				System.out.println("��׼");
			}else if(BMI>=25 && BMI<=29){
				System.out.println("����");
			}else if(BMI>=30 && BMI<=34){
				System.out.println("����");
			}else{
				System.out.println("�ǳ�����");
			}Well begun is half done
		}else{
			System.out.println("������������");
		}*/
		
		/**��������֤����ż����ŵ��������ͣ��ٳ�3���ٰ�������ŵ��������ͣ��ٺ�ż������ϵĻ���ͣ�����
		 * 10��ȥ����͵ĸ�λ�����ó�У���� 
		 * */
		Scanner scan = new Scanner(System.in);
		System.out.println("�����������룺");
		long txm=scan.nextLong();
		System.out.println("������У���룺");
		int xym=scan.nextInt();
		System.out.println("�����룺"+txm);
		System.out.println("У���룺"+xym);
		int a=0,b=0;
		for(int i=0;i<6;i++){
			a+=txm%10;
			txm/=10;
			System.out.println("a��"+a);
			b+=txm%10;
			txm/=10;
		}
		a=a*3+b;
		a=10-a%10;
		System.out.println("�������У���룺"+((a==xym)?"���":"��Ʒ"));
		

	}

}
