package day03;
/**
 * 打印 -128 ~ 127 的全部补码
 * i = -128 -127 ... 127   i++ 
 */
public class Demo06 {
	public static void main(String[] args) {
		for(int i=-128; i<=127; i++){
			String bin = Integer.toBinaryString(i);
			// i =-1 bin = "11111111... 11" 32个 bin.length()=32
		  // i = 0 bin = "0" bin.length()=1
		  // i = 1 bin = "1" bin.length()=1
		  // i = 7 bin = "111"  bin.length()=3
			//bin.length(); 获得字符串的长度, "0"长度1
			//"111" 长度是3
			int n = 32 - bin.length();//n 就是要输出"0"的个数
			// i=7  n=29
			for(int j=0; j<n; j++){//这个循环执行了n次
				//int j = 0 1 2 3 ... n-1 <n, j++  执行了n次
				System.out.print("0");//输出n个 '0'
			}
			System.out.println(bin);//再n个0以后输出bin内容
		}
	}
}
