package com.b;

public class MyException extends Exception{
	//自定义异常类会写入一个有参构造方法
	//参数表示的是错误信息
	public MyException(String str){
		super(str);
	}

	
	public static void main(String[] args) {
		// 异常的概念
		/*
		 * 异常的5个关键字
		 * 
		 * 
		 * 异常体系(所有异常体系种的类全是具体的类)
		 * Throwable所有异常的顶级父类
		 * 		->Error(错误)(例如内存益处这样的程序员解决不了的叫做“错误”)
		 * 		->Exception(异常)(和我们程序员相关的需要我们解决的异常)
		 * 				->RuntimeException(运行时异常)(例如5种常见异常)
		 * 
		 * 
		 * 异常分为检查型异常和非检查型异常：
		 * 检查型异常就是必须处理(捕获，抛出)的异常。例如：(继成)Exception
		 * 非检查型异常是处理和不处理都可以，叫做非检查型异常。例如：(继成)Error,RuntimeException
		 * 自定义异常：直接继成Exception类即可。
		 * 
		 */
		//自定义异常
		
	}

}
