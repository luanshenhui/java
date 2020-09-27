package day03;
/**
 * while 也可以用于计次循环 
 * 
 * 	for(;i<10;) 和 while(i<10) 完全等价！
 * 
 * 
 * 
 * 
 * 
 * 
 * 
 * 
 */
public class Demo13 {
	public static void main(String[] args) {
		int i=1;
		int sum = 0;
		for(;i<10;){//while(i<10){
			sum += i;
			i+=2;
		}
		System.out.println(sum);
	}
}
