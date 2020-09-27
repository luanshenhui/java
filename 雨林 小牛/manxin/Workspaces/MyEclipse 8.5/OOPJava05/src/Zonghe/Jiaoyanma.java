package Zonghe;
import java.util.*;

public class Jiaoyanma {

	public static void main(String[] args) {
		/**条形码验证：把偶数序号的数相加求和，再乘3，再把奇数序号的数相加求和，再和偶数序号上的积求和，再用
		 * 10减去这个和的个位数，得出校验码 
		 **/
//		Scanner scan = new Scanner(System.in);
//		System.out.println("请输入条形码：");
//		long tl = scan.nextLong();
//		System.out.println("请输入校验码：");
//		int jl = scan.nextInt();
//		System.out.println("条形码：" + tl);
//		System.out.println("校验码：" + jl);
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
//		System.out.println("您输入的校验码：" + ((a == jl) ? "真品" : "赝品"));
		
		/**身份证验证：S=Sum(Ai*Wi)，对前17位数字求和，最后一位是校验码
		 * Ai:表示第i位置上的身份证号数字值
		 * Wi：表示第i位置上的加权因子
		 * Wi：7,9,10,5,8,4,2,1,6,3,7,9,10,5,8,4,2
		 * 计算余数：Y=S%11
		 * 通过取余数得到相应的校验码
		 *      Y:0,1,2,3,4,5,6,7,8,9,10
		 * 校验码:1,0,X,9,8,7,6,5,4,3,2
		 * 如果得到余数为1则最后的校验码应该对应0，如果不是，则该身份证号不正确
		 */
		
		Scanner scan = new Scanner(System.in);
		System.out.println("请输入身份证号：");
		int[] Yi = {7,9,10,5,8,4,2,1,6,3,7,9,10,5,8,4,2};
		char[] J = {'1','0','X','9','8','7','6','5','4','3','2'};
		long id = scan.nextLong();
		int b = String.valueOf(id).length();
		long a = 0;
		long Ji = id % 10;	//取出最后一位
		id = id / 10;	//剩下17位
		
		System.out.println("身份证号为：" + id);
		System.out.println("最后一位验证码为：" + Ji);
		
		for(int i = 0;i < b - 1;i++){
			a = a*10+id%10;
			id /= 10;
		}
		System.out.println("id倒置：" + a);
		
		int sum = 0;
		for(int i = 0; i < Yi.length; i++){
			sum += (a%10)*Yi[i];
			a /= 10;
		}
		System.out.println("前17位数求和：" + sum);
		
		int Y = 0;
		Y = sum % 11;
		System.out.println("余数为：" + Y);
		
		char JYM = Long.toString(Ji).charAt(0); 
		for(int i = 0;i < J.length; i++){
			if(J[Y] == JYM){
				System.out.println("您的身份证号 是对的");
				break;
			}else{
				System.out.println("您的身份证号 是错的");
				break;
			}
		}
		System.out.println("得到的校验码：" + J[Y]);
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
	}
}
