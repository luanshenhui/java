package day02;
/**
 * 赋值运算
 * 赋值表达式：赋值表达式是有值的
 * 
 * 复合赋值运算 
 *   +=  -=  /=  %=
 */
public class Demo11 {
	public static void main(String[] args) {
		int a;
		a = 1;
		System.out.println(a = 9);
		// 1) 执行赋值操作 a的值改为9
		// 2) 赋值操作的结果9作为 赋值表达式(a=9)的结果9
		
		int b, c, d;
		d = (c = (b = (a = 8)));
		System.out.println(d);//8
		
		c = 3+(a=a++);
		System.out.println(c+","+a); // 11 8 
		
		a = 1;
		a += 2;  //a = a + 2;
		System.out.println(a);//3
		a = 2;
		a *= 4; //a = a*4;
		System.out.println(a);//8
		System.out.println("--------------");
		//将一个整数，按照10进制每个数字拆开
		// 将一个整数 倒过来
		
		int sum = 0;
		int num = 34678;
		int last = num%10;
		sum = sum * 10 + last;
		System.out.println(last);//8
		num /= 10;//3467   num = 34678 / 10
		last = num%10;//7
		sum = sum * 10 + last;//87
		System.out.println(last);//7
		num /= 10;
		last = num%10;
		sum = sum * 10 + last;//876
		System.out.println(last);num /= 10; last = num%10;
		sum = sum * 10 + last;
		System.out.println(last);
		num /= 10; 
		last = num%10;
		sum = sum * 10 + last;
		System.out.println(last);
		System.out.println(sum); 
	}
}






