package day06;
/**
 * ���Ե���ģʽ
 * @author Administrator
 *
 */
public class SingleDemo {
	public static void main(String[] args) {
		Singleton s1 = Singleton.getSingleton();
		Singleton s2 = Singleton.getSingleton();
		Singleton s3 = Singleton.getSingleton();
		System.out.println(s1 == s2);
		System.out.println(s3 == s2);
	}
}
