package test;
/*
 * 方法  java叫方法  动作  你能干什么   为什么要学习方法?
 * 
 * b/s browser/server 浏览器  服务器
 * c/s  客户端  服务器
 * 
 * 方法无非有两种  一种 static修饰的 使用static修饰的方法比较少
 *            对象来调用方法
  */
public class Demo6 {
	public static void main(String[] args) {
		//现在要做的就是把两个已经定义的数  加起来
		//现在这么做比较麻烦  想一下计算器
//		int a = 1;
//		int b = 2;
//		int c = a + b;
//		System.out.println(c);
//		
//		int d = 1;
//		int e = 2;
//		int f = d + e;
//		System.out.println(f);
//		
//		int g = 1;
//		int h = 2;
//		int i = g + h;
//		System.out.println(i);
		// 不管是多么复杂的代码  都是一行一行执行的  顺序执行顺序
		//如果你想调用某个方法  那么参数必须一一对应
		// 方法的调用者并不清楚方法的具体实现 只有方法的实现者才知道方法里具体的业务逻辑
		int z = add(4,5);
		int aa = add(2,3);
		System.out.println(z);
	}
	//方法 就是动作  格式   public  方法的返回值类型  方法的名字 （）｛｝
	//方法的返回值类型就是你进行运算或者操作之后 的值的类型
	//为什么方法要有返回值呢？ 不管做什么  都会有一个结果  eg：追女孩  同意  不同意
	//static 静态的  static修饰方法的时候  
	//1.方法可以直接由类名调用  Demo6.add（1，2）在其他类的时候
	//2。在本类中 可以直接写方法的名字来调用
	public static int add(int a, int b){
		int c = a + b;
		return c;
	}
}
class a {
	//在其他的类中 你还想调用static修饰的方法  那么使用类名.方法名字来调用
	public void test(){
		Demo6.add(1, 2);
	}
}

