package com.yulin.pm;
import java.util.*;

public class CaiShuSheng {

	public static void main(String[] args) {
		CaiShuSheng css = new CaiShuSheng();
		css.show();

	}
	
	//��������� �����ظ�������
	private int[] create(){
		Random rd = new Random();
		int[] rand = new int[10];	
		for(int i=0;i<rand.length;i++){
			int in=rd.nextInt(10);//*****ע�������
			rand[i]=in;
			for(int j=0;j<i;j++){
				if(rand[j]==in){
					i--;
				}
			}
		}
		return rand;
	}
	
	//����4����
	private int[] input(){	
		Scanner scan = new Scanner(System.in);
		int[] input=new int[0];
		System.out.println("������1000~9999֮������֣�");
		int in=scan.nextInt();
		int length = Integer.toString(in).length();
		input=Arrays.copyOf(input, length);
		for(int i=input.length-1;i>=0;i--){
			input[i]=in%10;
			in/=10;
		}
		
		return input;
	}
	
	//��֤����
	private int check1(int[] rand,int[] input){
		int count=0;
		for(int i=0;i<rand.length;i++){
			for(int j=0;j<input.length;j++){
				if(rand[i]==input[j]){
					count++;
					break;
				}
			}
		}
		return count;
	}
	
	//��֤����λ�ö���
	private int check2(int[] rand,int[] input){
		int count=0;
		System.out.println(rand.length+","+input.length);
		for(int i=0;i<rand.length;i++){
			if(rand[i]==input[i]){
				count++;
			}
		}
		return count;
	}
	
	//ѡ���Ѷ� �����������
	int level=0;
	private int[] select1(){
		System.out.println("��ѡ���Ѷȣ�1.�� 2.�м� 3.���� 4.��ʦ");
		Scanner scan = new Scanner(System.in);
		int in=scan.nextInt();
		int[] rand=create();	
		if(in==1){
			rand=Arrays.copyOf(rand, 4);
			level=4;
		}else if(in==2){
			rand=Arrays.copyOf(rand, 6);
			level=6;
		}else if(in==3){
			rand=Arrays.copyOf(rand, 8);
			level=8;
		}else if(in==4){
			rand=Arrays.copyOf(rand, 10);
			level=10;
		}
		return rand;
	}
	
	//��װ����
	public void show(){
		System.out.println("~~~~~~~~~��Ϸ��ʼ~~~~~~~~~");
		int[] rand=select1();
		System.out.println(Arrays.toString(rand));
		int[] input=input();
		System.out.println(Arrays.toString(input));
		int count=1;
		while(true){
			int a=check1(rand, input);
			int b=check2(rand, input);
			System.out.println(a+","+b);
			if(b==level){
				System.out.println("��Ϸ������");
				System.out.println("��һ�����ˣ�"+count+"��");
				break;
			}else{
				input=input();
				count++;
			}
		}
	}
	
	
	
	
	

}
