package com.yulin.pm;
import java.util.*;

public class CaiShuAnli {
	/**
	 * ��������Ϸ��
		1.�������4����λ��
		2.�����̨������µ���
		3.��ʾ��µĽ��a,b
		4.a��ʾ���Եĸ���
		5.b��ʾ������λ�ö��Եĸ���
		6.ȫ��������Ϸ��������ʾ�µĴ���
		
		������ѡ����Ϸ�ȼ����򵥣��м������ѣ���ʦ���ֱ��4,6,8,10������
	 */
	public static void main(String[] args) {
		CaiShuAnli cs = new CaiShuAnli();
		cs.start();
	}
	
	private int check1(int[] rand,int[] input){	//����У�����Եĸ���
		int count=0; //��¼����
		for(int i=0;i<rand.length;i++){
			for(int j=0;j<input.length;j++){
				if(rand[i]==input[j]){
					count++;
					break;  //���������ѭ��
				}
			}
		}
		return count;
	}
	
	private int check2(int[] rand,int[] input){	//����У������λ�ö��Եĸ���
		int count=0;
		for(int i=0;i<rand.length;i++){
			if(rand[i]==input[i]){
				count++;
			}
		}
		return count;
	}
	
	private int[] create(){	//�������һ������Ϊ4���������飬Ԫ�ص�ֵΪ0~9
		Random rd = new Random();
		int[] rand=new int[4];
		for(int i=0;i<rand.length;i++){
			rand[i]=rd.nextInt(10);
		}
		return rand;
	}
	
	private int[] input(){	//�ӿ���̨����һ������Ϊ4���������飬Ԫ�ص�ֵΪ0~9
		int[] input=new int[4];
		Scanner scan = new Scanner(System.in);
		System.out.println("����1000~9999�е�һ������");
		int in=scan.nextInt();
		for(int i=3;i>=0;i--){
			input[i]=in%10;	//���4λ��
			in/=10;
		}
		return input;	
	}
	
	public void start(){	//��װ����
		System.out.println("~~~~~~~��Ϸ��ʼ~~~~~~");
		int[] rand = create();	//ͨ��create��������һ������
		System.out.println(Arrays.toString(rand));
		int[] input=input();	//ͨ��input��������һ������
		System.out.println(Arrays.toString(input));
		int count=1;	//�ӵ�һ�ο�ʼ������
		while(true){
			int a=this.check1(rand, input);
			int b=this.check2(rand, input);
			System.out.println(a+","+b);
			if(b==4){
				System.out.println("��Ϸ������");
				System.out.println("��һ������"+count+"��");
				break;
			}else{
				count++;
				input=input();	//���ûȫ���У����������
			}
		}		
	}
}
