package day02;
/**
 * ��ֵ����
 * ��ֵ���ʽ����ֵ���ʽ����ֵ��
 * 
 * ���ϸ�ֵ���� 
 *   +=  -=  /=  %=
 */
public class Demo11 {
	public static void main(String[] args) {
		int a;
		a = 1;
		System.out.println(a = 9);
		// 1) ִ�и�ֵ���� a��ֵ��Ϊ9
		// 2) ��ֵ�����Ľ��9��Ϊ ��ֵ���ʽ(a=9)�Ľ��9
		
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
		//��һ������������10����ÿ�����ֲ�
		// ��һ������ ������
		
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






