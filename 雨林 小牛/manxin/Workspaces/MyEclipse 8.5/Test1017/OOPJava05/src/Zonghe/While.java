package Zonghe;
import java.util.*;

public class While {

	/**
	 * ����whileѭ���ӿ���̨�����������������������ֵΪ0ʱ���������룬�����������
	 */
	public static void main(String[] args) {
		Scanner scan = new Scanner(System.in);
		int max = 0;
		while(true){
			System.out.println("������һ������:");
			int in = scan.nextInt();
//			max = in;
			if(in == 0){
				System.out.println("����0ʱ������");
				break;
			}
			if(in > max){
				max = in;
//				break;
			}
		}
		System.out.println("���ֵΪ��" + max);

	}

}
