package day03;
/**
 * 输出24的全部约数，1 和自身除外 
 * 
 *
 */
public class Demo11 {
	public static void main(String[] args) {
		
		int n = 24;
		// i = 2 ~ <=24/2   i++
		for(int i=2; i<=n/2; i++){
			if(n%i==0){
				System.out.println(i);
			}
		}
	}
}
