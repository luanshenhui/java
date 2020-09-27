package day04;
/**
 * 1）final类不能被继承
 * 2）final类可以阻止子类进行重写修改
 * 3）Java API 中常见final类：String Math Integer 包装类 
 *    这些类是final的就是为了避免用户对API的修改！
 * 4) 一般很少使用final类，final类阻止了继承，也阻止了动态
 *   代理技术使用（Struts Hibernate Spring ）
 */
public class Demo04 {
	public static void main(String[] args) {

	}
}
final class Goo{
}
//class Koo extends Goo{}//编译错误，不能继承final类
//class MyString extends String{}//编译错 不能继承final类