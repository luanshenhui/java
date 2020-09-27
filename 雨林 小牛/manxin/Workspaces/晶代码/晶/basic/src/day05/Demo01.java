package day05;

import java.util.Random;
import java.util.Scanner;

/**
 * 
 * 字母猜测游戏
 * 
 * 业务规则描述：猜测“随机生成”的字符系列（5个）,
 * 根据“用户输入”的字符序列“检查”是否猜测成功，
 * 如果不成功就“提示”猜中情况，继续猜测。
 *  
 * 业务数据分析：
 *   1) char[] answer 被猜测字母序列
 *   2) char[] input  用输入的字母序列
 *   3) int count 猜测次数   
 *   4) int[] result = {字符匹配数量，匹配成功位置}  
 *    用户输入的序列和被猜测序列的比较结果
 * 功能分析设计
 *   1）随机生成 (generate)
 *      方法算法功能描述：生成n个不重复的大写字母
 *      char[] generate(int n)
 *      
 *   2）用户输入(Input)
 *   	   方法算法功能描述：从控制台读取输入，返回5个大写字符
 *      char[] userInput()
 *      
 *   3）检查(check)用户输入
 *   方法算法功能描述：检查标准答案（answer）和用户输入
 *   （input），返回结果：{字符匹配数量，匹配成功位置} 
 *      int[] check(char[] answer, char[] input)
 *      
 *   4）

 *     void show(int count, int[] result)
 *     
 *   5) main 方法完成猜测流程控制
 * 		1）"生成答案"字符序列：5个字符
 * 		2）等待用户的答案输入
 * 		3）"检查用户输入"的答案，检查结果包含 匹配数量和匹配位置
 * 		4) 统计回答数量
 * 		5) 提示检查结果, 返回 (2)
 */
public class Demo01 {
	public static void main(String[] args) {
		char[] answer;
		char[] input;
		int count=0;
		int[] result;
		//由static修饰的方法或者属性  可以直接由类名调用
		answer = Demo01.generate(5);//1）"生成答案"字符序列：5个字符
		System.out.println(answer);
		System.out.println("欢迎使用猜字符游戏！");
		while(true){
			input = userInput();//2)等待用户的答案输入
			result = check(answer, input);//"检查用户输入"的答案
			count++;//统计回答数量
			show(count, result);//提示检查结果
			if(result[0]==5 && result[1]==5){
				break;
			}
		}
	}
	public static char[] generate(int n){
		char[] chs = {'A','B','C','D','E','F','G','H'};
		//boolean类型默认的是false
		//为了让随机数不是重复得的
		boolean[] used = new boolean[chs.length];
		int i;
		int index = 0;
		//是把每一个随机出来的字母放到了answer里
		char[] answer = new char[n];
		Random r = new Random();
		do{
			i = r.nextInt(chs.length)+0;
			//used的数组里的某一个元素是true
			if(used[i]){//如果使用过i就继续下次循环
				continue;
			}
			//chs[i]代表的是随机出来的是哪一个字母
			//把选出的那个数放到answer数组里面
			answer[index++] = chs[i];
			//因为重复的元素是不可以在answer这个数组里的
			used[i] = true;
		}while(index != n);
		return answer;
	}
	public static char[] userInput(){
		Scanner in = new Scanner(System.in);
		char[] input = {};
		while(true){
			System.out.print("尽力猜吧：");
			String str = in.nextLine();
			// String 提供的 API方法，返回字符串中所有的字符。
			// "ABCDE" toCharArray 返回 {A, B, C, D, E}
			input = str.toCharArray();
			if(input.length == 5){
				break;
			}
			System.out.println("长度不对呀!"); 
		}
		return input;
	}
	/*
	 * int[] a = {1,2,3}
	 * int[] b = {4,3,1}
	 */
	public static int[] check(char[] answer, char[] input){
		int[] result = {0,0};
		for(int i=0; i<answer.length; i++){
			for(int j=0; j<input.length; j++){
				if(answer[i]==input[j]){
					result[0]++;
					if(i==j){
						result[1]++;
					}
					break;
				}
			}
		}
		return result;
	}
	public static void show(int count, int[] result){
		System.out.print("猜测"+count + "次" );
		System.out.print(" 匹配字符"+ result[0] + "个" );
		System.out.println(" 匹配位置"+ result[1] + "次" );
		if(result[0] == 5 && result[1]==5){
			System.out.println("恭喜，猜中！");
		}
	}
}












