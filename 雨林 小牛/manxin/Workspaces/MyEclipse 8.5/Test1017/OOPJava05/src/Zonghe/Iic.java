package Zonghe;
import java.util.*;

public class Iic {

	/**
	 * ����ܵڶ������
	 * ���50
	 * �����°�
	 */
	public static void main(String[] args) {
		for(int ku = 50;ku > 0;){
			System.out.println("�����1��4Ԫ���ڶ������");
			System.out.println("��滹ʣ��" + ku);			
			System.out.println("��Ҫ������");
			Scanner scan = new Scanner(System.in);
			int in = scan.nextInt();
			if(in > ku){
				System.out.println("û����ô�࣡������ѡ��");
			}else{
				int sum = 0;
				sum = in/2*6 + in%2*4;
				ku -= in;
				System.out.println("��һ��������" + in +"����һ����" + sum + "Ԫ");
			}
		}
		System.out.println("�Ѿ������ˣ������°���");

	}

}
