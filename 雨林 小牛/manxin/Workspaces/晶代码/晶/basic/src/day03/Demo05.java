package day03;
/**
 * for 循环
 * “经典”的for循环使用：
 * 
 * for(初始化(1);循环条件(布尔表达式)(2);递增表达式(4)){
 * 	 //循环体 语句块(3)
 * } 
 * (5)
 * for循环的执行的流程：
 * (1)->{(2)-true->(3)->(4)}->{(2)-true->(3)->(4)}->
 * (2)-false->(5)结束
 */
public class Demo05 {
	public static void main(String[] args) {
		//10 以内的奇数和累加
		int sum = 0;/*0*/
		for(int i=1/*1*/; i<10/*2*/; i+=2/*4*/){
			//for循环定义了变量 i=1 3 5 7 9 (11 结束)
			sum += i;/*3*/
		}
		System.out.println(sum);/*5*/
/*(0 sum=0)->(1 i=1)->
 *(2 1<10)-true->(3 sum=1)->(4 i=3)->
 *(2 3<10)-true->(3 sum=4)->(4 i=5)->
 *(2 5<10)-true->(3 sum=9)->(4 i=7)->
 *(2 7<10)-true->(3 sum=16)->(4 i=9)->
 *(2 9<10)-true->(3 sum=25)->(4 i=11)->
 *(2 11<10)-false->(5 println(25))
 */
	}
}








