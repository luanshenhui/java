package day02;
/**
 * ���صķ������ù��� 
 * Java ���ݲ������ͣ������ܼ�ת����ԭ�� �������ط���
 *                   ���ͽ�ԭ��
 */
public class Demo02 {
	public static void main(String[] args) {
		Foo foo = new Foo();
		foo.test(5.0);
		foo.test(5);
	}
	public Demo02() {
		// TODO Auto-generated constructor stub
	}
	public Demo02(int a){
		
	}
	
}
class Foo{
//	public void test(int a){
//		System.out.println("test(int)"); 
//	}
	public void test(double a){
		System.out.println("test(double)"); 
	}
	public void test(float a){
		System.out.println("test(float)"); 
	}
	public void test(long a){
		System.out.println("test(long)"); 
	}
}