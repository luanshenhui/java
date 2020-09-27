package day05;

import java.util.Arrays;

/**
 * Arrays 
 *  equals 方法： 用于比较两个数组内容相等  
 * 使用API方法：API方法封装了常用算法功能，使用这些功能
 *    简化开发过程， 提高开发效率
 * 如：使用toString可以便捷输出数组内容
 *    使用equals可以便捷比较 数组内容
 * API 封装的算法也是 for if 实现的！也可以不用。
 */
public class Demo03 {
	public static void main(String[] args) {
		char[] answer = {'A', 'C', 'D'};
		char[] input = {'A', 'C', 'D'}; // {'A', 'B', 'C'}; 
		boolean match = Arrays.equals(answer, input);
		//match 匹配
		if(match){
			System.out.println("答对了！"); 
		}else{
			System.out.println("答错了！"); 
		}
	}
}
