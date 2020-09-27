package com.a;

public class B {
	public static void main(String[] args) {
		/*
		 * java对于异常的处理方案有2个
		 * 1，捕获处理(自己处理)：try，catch，finally
		 * try;包含可能出现异常的代码
		 * catch：捕获对应的异常，然后输出异常信息，或记录异常信息
		 * finally:不论是否有异常抛出，都一定会执行的语句块。
		 * 2，抛出(调用的处理)；throw，throws
		 * throw：在代码在函数(语句块中)内部抛出异常。
		 * throws：在函数声明，定义处声明抛出异常。
		 */
		try{
		String str=null;
		//当出现异常时程序会立刻终止并抛出异常//后面程序终止
			System.out.println(str.equals("abc"));
		}catch(NullPointerException e){
			//输出异常信息
			e.printStackTrace();
			System.out.println("捕获后和抛出的一样就执行我");
		}catch(ArithmeticException e){
			//输出异常信息
			e.printStackTrace();
			System.out.println("捕获后和抛出的一样就执行我");
		}catch(/*ArrayIndexOutOfBounds*/Exception e){
			//输出异常信息
			e.printStackTrace();
			System.out.println("捕获后和抛出的一样就执行我");
		}finally{
			System.out.println("最终执行的语句块");
		}
		}
}
