package day03;
/**
 * while Ҳ�������ڼƴ�ѭ�� 
 * 
 * 	for(;i<10;) �� while(i<10) ��ȫ�ȼۣ�
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
