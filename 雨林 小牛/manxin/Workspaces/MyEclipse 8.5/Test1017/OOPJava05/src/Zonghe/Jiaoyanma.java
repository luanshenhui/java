package Zonghe;
import java.util.*;

public class Jiaoyanma {

	public static void main(String[] args) {
		/**��������֤����ż����ŵ��������ͣ��ٳ�3���ٰ�������ŵ��������ͣ��ٺ�ż������ϵĻ���ͣ�����
		 * 10��ȥ����͵ĸ�λ�����ó�У���� 
		 **/
//		Scanner scan = new Scanner(System.in);
//		System.out.println("�����������룺");
//		long tl = scan.nextLong();
//		System.out.println("������У���룺");
//		int jl = scan.nextInt();
//		System.out.println("�����룺" + tl);
//		System.out.println("У���룺" + jl);
//		int a = 0,b = 0;
//		for(int i = 0; i < 6;i++){
//			a += tl % 10;
//			tl /= 10;
//			System.out.println("a=" + a);
//			b += tl % 10;
//			tl /= 10;
//		}
//		a = a * 3 + b;
//		a = 10 - a%10;
//		System.out.println("�������У���룺" + ((a == jl) ? "��Ʒ" : "��Ʒ"));
		
		/**���֤��֤��S=Sum(Ai*Wi)����ǰ17λ������ͣ����һλ��У����
		 * Ai:��ʾ��iλ���ϵ����֤������ֵ
		 * Wi����ʾ��iλ���ϵļ�Ȩ����
		 * Wi��7,9,10,5,8,4,2,1,6,3,7,9,10,5,8,4,2
		 * ����������Y=S%11
		 * ͨ��ȡ�����õ���Ӧ��У����
		 *      Y:0,1,2,3,4,5,6,7,8,9,10
		 * У����:1,0,X,9,8,7,6,5,4,3,2
		 * ����õ�����Ϊ1������У����Ӧ�ö�Ӧ0��������ǣ�������֤�Ų���ȷ
		 */
		
		Scanner scan = new Scanner(System.in);
		System.out.println("���������֤�ţ�");
		int[] Yi = {7,9,10,5,8,4,2,1,6,3,7,9,10,5,8,4,2};
		char[] J = {'1','0','X','9','8','7','6','5','4','3','2'};
		long id = scan.nextLong();
		int b = String.valueOf(id).length();
		long a = 0;
		long Ji = id % 10;	//ȡ�����һλ
		id = id / 10;	//ʣ��17λ
		
		System.out.println("���֤��Ϊ��" + id);
		System.out.println("���һλ��֤��Ϊ��" + Ji);
		
		for(int i = 0;i < b - 1;i++){
			a = a*10+id%10;
			id /= 10;
		}
		System.out.println("id���ã�" + a);
		
		int sum = 0;
		for(int i = 0; i < Yi.length; i++){
			sum += (a%10)*Yi[i];
			a /= 10;
		}
		System.out.println("ǰ17λ����ͣ�" + sum);
		
		int Y = 0;
		Y = sum % 11;
		System.out.println("����Ϊ��" + Y);
		
		char JYM = Long.toString(Ji).charAt(0); 
		for(int i = 0;i < J.length; i++){
			if(J[Y] == JYM){
				System.out.println("�������֤�� �ǶԵ�");
				break;
			}else{
				System.out.println("�������֤�� �Ǵ��");
				break;
			}
		}
		System.out.println("�õ���У���룺" + J[Y]);
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
	}
}
