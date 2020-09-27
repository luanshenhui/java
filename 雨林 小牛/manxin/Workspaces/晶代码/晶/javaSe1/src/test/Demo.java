package test;
/*
 * java 计算机中的语言  在计算机中你能做一些事情
 * java为什么是跨平台？ jvm  java虚拟机    
 * 八种基本数据类型：小到大
 * boolean byte char short int float double long
 * 1/8byte   8     16   16  32   32   64    64
 */
public class Demo {
	//主方法  也就是程序的入口  暂时的理解
	//什么叫方法  动作  干了什么事
	public static void main(String[] args) {
		//类型：int  double 
		//变量的格式：变量的类型   变量名字  =  值
		//类型要与值相对应
		int fdsfds =1;
		//变量名字的命名规范：以字母 下划线 $ 开头  后面可以接字母 下划线 $ 数字
//		int a = 1;
//		int _ = 1;
//		int $ = 1;
//		int a12 = 1;
		int a = 1;
		int b = 2;
		int c = a + b;
		
		
		//if(boolean表达式 = true){}
		
		if(1==1){
			System.out.println("你对了");
		}else{
			System.out.println("ni jiu chi");
		}
		//1243243243.......... 
		for (int i = 0; i < 10; i=i+1) {
			System.out.println(i);
		}
		//while和do while 的区别:  while先判断后执行   dowhile 是先执行后判断 至少执行一此
//		while(true){
//			
//		}
//		do {
//			
//		} while (condition);
//		//(整型表达式)
//		switch(){
//		case 1 :
//		}
		//强制类型转换  就是将大类型转换为小的类型
		byte a1 =1;
		byte b1 =2;
		byte c1 =(byte)(a1 + b1);
	}
}
