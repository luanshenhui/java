package day03;
/**
 * PI = 4 * (1/1-1/3 + 1/5-1/7 + 1/9-1/11 ... ) 
 *     (1/1-1/3) + (1/5-1/7) + (1/9-1/11) ...
 *i =     1           5           9         ... n   i+=4 
 *sum +=(1.0/i-1.0/(i+2))  
 */
public class Demo07 {
	public static void main(String[] args) {
		double sum = 0;
		for(long i=1; i<500000000L; i+=4){
			//i=1 5 9 13 ... < 1000000
			sum += 1.0/i - 1.0/(i+2);
		}
		double pi = sum*4;
		System.out.println(pi);  
	}
}
