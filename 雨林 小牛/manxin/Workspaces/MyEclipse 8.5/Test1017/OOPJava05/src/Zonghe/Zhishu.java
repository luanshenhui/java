package Zonghe;
import java.util.*;

public class Zhishu {

	/**
	 * 1.�ж�һ�����Ƿ�������
	 * ������ֻ�ܱ�1����������������
	 * 
	 * 2.���20���ڵ�����
	 */
	public static void main(String[] args) {
		// 1.
		Scanner scan = new Scanner(System.in);
		System.out.println("������һ�����֣�");
		int in = scan.nextInt();
		int count = 0;
		for(int i = 1; i <= in; i++){
			if(in % i == 0){
				count++;
			}
		}
		if(count == 2){
			System.out.println("���������������");
		}else{
			System.out.println("������Ĳ���������");
		}
		
		//2.
		int count1 = 0;
		for(int i = 1;i <= 20;i++){
			count1 = 0;
			for(int j = 1; j <= i; j++){
				if(i % j == 0){
					count1++;
				}
			}
			if(count1 == 2){
				System.out.println("20���ڵ�������" + i);
			}
		}
		
	}

}
