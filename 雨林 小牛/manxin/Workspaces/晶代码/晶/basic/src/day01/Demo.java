package day01;
/**
 * 编译错误：在代码编译期间发生的错误，如果有编错误，就不能
 *   生成.class 更不可能运行！ 
 * 编译错误的处理： 
 *   1）查看编译错误消息!  
 *   2) 根据提示修改代码，解决问题
 */
public class Demo {
  public static void main(String[] args) {
//    //System.out.println(age);//编译错误，找不到age变量！
//    int age;//定义/声明 一个变量
//    //System.out.println(age);//编译错误，age变量可能没有初始化
//    age = 2;//初始化，就是第一次赋值
//    System.out.println(age);//2
//    //int age = 5;//编译错误，重复的局部变量
//    age = 5;//对age 进行赋值
//    System.out.println(age);//5
//    {
//      int score = 20;//定义变量直接初始化，score 分数
//      System.out.println(score);// 20
//      System.out.println(age);
//    }
//    //System.out.println(score);//编译错误，没有变量score
//    int score = 100;
//    System.out.println(score);//100
//    //System.out.println(socre);//编译错误，变量没有定义
//    //这个编译错误的原因是：变量名拼写错误！
	  
	  
	  //age没有被声明  
	  //System.out.println(age);
	  
	  int age;//声明 
	  age = 5;
	  age = 6;
	  
	  int age1 = 6;
	  //代码块
	  {
		  int age2 = 2;
	  }
//	  /带红X的是编译错误 
	  System.out.println(age1);
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
  }
}








