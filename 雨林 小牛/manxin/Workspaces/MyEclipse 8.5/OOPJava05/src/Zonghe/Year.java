package Zonghe;
import java.util.*;

public class Year {

	/**
	 * ����һ����ݣ��ж��Ƿ�������
	 * ���꣺�ܱ�4���������ܱ�100���������ǿ��Ա�400����
	 */
	public static void main(String[] args) {
		Scanner scan = new Scanner(System.in);
		while(true){
			System.out.println("������һ����ݣ�");
			int year = scan.nextInt();
			if(year % 4 == 0 && year % 100 != 0 || year % 400 == 0){
				System.out.println(year + "������");
			}else{
				System.out.println("��������");
			}
		}
	}

}
