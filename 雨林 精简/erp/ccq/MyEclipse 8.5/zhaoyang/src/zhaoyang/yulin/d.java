package zhaoyang.yulin;

public class d {
public static void main(String[] args) {
	String s1="你好";//每次都会到内存中去找“你好”字符串
	//有就直接使用，没有就创建新的对象
	
	String s2="你好";
	boolean boo=(s1==s2);
	System.out.println(boo);
	//类的初始化顺序
	//当创建一个对象时，JVM先加载静态
	
	//final 关键字修饰变量表式常量，在野不能被更改
	//static 关键字和final关键字关系紧密，成员变量通常使用static final一起修饰
	
	
}
}
