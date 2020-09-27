package day03;
/**
 * 2) 如果父类没有无参数构造器,子类必须使用super() 调用
 *  父类的构造器.
 * 编程建议: (Java Bean规范)所有类都提供无参数构造器!
 */
public class Demo04 {
	public static void main(String[] args) {
		Boo b = new Boo();
	// 输出结果: A.编译错   B.运行异常   C.无   D.Aoo(int)
	}
}
class Aoo{
	Aoo(int a){
		System.out.println("Aoo(int)"); 
	}
}
//class Boo extends Aoo{}//编译错误, 没有无参数Aoo()构造器
class Boo extends Aoo{
	//Boo(){}//编译错误, Aoo类中没有 Aoo()构造器
	Boo(){
		//super();//编译错误.
		super(8);//调用 Aoo 的 Aoo(int) 构造器
	}
}



