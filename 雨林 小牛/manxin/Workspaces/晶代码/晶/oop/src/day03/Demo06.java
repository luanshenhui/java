package day03;
/**
 * 重载的方法是根据参数类型调用的
 * 重载的方法: 方法名一样, 参数列表或者叫参数类型不同的方法
 */
public class Demo06 {
	public static void main(String[] args) {
		Qoo q = new Qoo();
		q.test(1);//调用 q.test(int)
		q.test(1L);//调用 q.test(long)
		q.test('a');
	}
	public void test(char a){
		System.out.println("test(char)");
	}
}
class Qoo  extends Demo06{
	public void test(int a){
		System.out.println("test(int)");
	}
	public void test(long a){
		System.out.println("test(long)");
	}
}
