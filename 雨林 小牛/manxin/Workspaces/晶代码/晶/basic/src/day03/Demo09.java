package day03;
/**
 * 有数字 n， 要求按照进制补齐 0 输出 
 *   n = 90, 输出补齐 8位，如: 00000090
 * 
 * 1) 计算输出以后的长度
 * 2) 计算出补齐“0”的个数
 * 3) for循环补齐0
 * 4) 输出数字
 */
public class Demo09 {
	public static void main(String[] args) {
		int n = 90;
		String txt = Integer.toString(n);//90 -> "90" 
		int count = 8 - txt.length();//6
		for(int i=0; i<count; i++){
			//i = 0 1 2 3 4 5 <6
			System.out.print("#");
		}
		System.out.println(txt); 
	}
}



