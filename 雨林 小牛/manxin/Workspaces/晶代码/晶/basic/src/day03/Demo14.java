package day03;
/**
 * ��תһ������ num = 37195  �����59173 
 * 
 * String 
 * 
 * 
 * 
 * 
 * 
 * 
 * 
 * 
 * 
 * 
 * 
 */
public class Demo14 {
	public static void main(String[] args) {
		int num = 37195;
		int sum = 0;
		while(true){
			int last = num % 10; //5   9   1    7     3
			sum = sum*10+last; //5    59  591  5917  59173
			num /= 10; //3719         371  37   3     0
			System.out.println(last+","+num+","+sum); 
			if(num==0){
				break;
			}
		}
		System.out.println(sum); 
		
//		int last = num % 10;//5
//		sum = sum*10+last;//sum=5
//		num /= 10;//3719
//		
//		last = num % 10;//9
//		sum = sum*10+last;//sum=59
//		num /= 10;//371
//		
//		last = num % 10;//1
//		sum = sum*10+last;//sum=591
//		num /= 10;//37
//		
//		last = num % 10;//7
//		sum = sum*10+last;//sum=5917
//		num /= 10;//3
//		
//		last = num % 10;//3
//		sum = sum*10+last;//sum=59173
//		num /= 10;//0 ����ѭ������������ num==0
//		
		
	}
}
