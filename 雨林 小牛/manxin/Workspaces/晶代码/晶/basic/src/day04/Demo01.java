package day04;
/**
 * while和do  while的区别  while是先判断再执行  do  while是先执行后判断
 * do while至少执行一次 
 * 
 * do{
 *   //循环体(1)
 * }while(循环条件(2));
 * 
 * 执行流程：
 * {(1)->(2)}-true->{(1)-(2)}-true->{(1)->(2)}-false->结束
 * 
 * 特点：循环结束条件在循环最后的位置判断，循环体先被执行
 * 示例：将一个整数反转过来 
 *   1) 取出整数的最后一位
 *   2) 累加
 *   3) 整数消去最后一位
 *   4) 如果整数不为零 返回 (1)
 */
public class Demo01 {
	public static void main(String[] args) {
		int num = 52833;
		int sum = 0;
		do{
			int last = num%10;
			sum = sum*10 + last;
			num /= 10;
			System.out.println(last+","+num+","+sum); 
		}while(num != 0);//如果 num!=0 返回true 就再次执行循环 
		System.out.println(sum); 
	}
}



