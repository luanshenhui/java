package Zonghe;
import java.util.*;

public class Daozhi {

	/**
	 * �������
	 */
	public static void main(String[] args) {
		// 1.
//		int i = 12345;
//		System.out.println("�������ǰ��"+ i );
//		int a = 0;
//		a = a*10+i%10;
//		i /= 10;
//		a = a*10+i%10;
//		i /= 10;
//		a = a*10+i%10;
//		i /= 10;
//		a = a*10+i%10;
//		i /= 10;
//		a = a*10+i%10;
//		i /= 10;
//		System.out.println("���������"+ a );
//		for(int j =0 ;j < 5;j++){
//			a = a*10+i%10;
//			i /= 10;
//		}
//		System.out.println("���������"+ a );
		
		//2.
		Scanner scan = new Scanner(System.in);
		System.out.println("������һ�����֣�");
		int num = scan.nextInt();
		System.out.println("����������ǣ�" + num);
		int a = 0;
		int b = String.valueOf(num).length();
		for(int i = 0; i < b; i++){
			a = a*10+num%10;
			num /= 10;
		}
		System.out.println("���������"+ a);
	}

}
