package Zonghe;
import java.util.*;

public class Shuzu {

	/**
	 * ��������ֲ����ظ�
	 */
	public static void main(String[] args) {
		Scanner scan = new Scanner(System.in);
		int arr[] = new int[5];
		int in;
		for(int i = 0;i < arr.length; i++){
			System.out.println("������5��������");
			in = scan.nextInt();
			arr[i] = in;
			for(int j = 0;j < i; j++){
				if(arr[j] == in){
					i--;
					System.out.println("��������������ظ������������룡");
				}
			}
		}
		
		System.out.println(Arrays.toString(arr));
	}

}
