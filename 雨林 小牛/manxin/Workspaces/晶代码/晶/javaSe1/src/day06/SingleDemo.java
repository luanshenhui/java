package day06;
/**
 * ²âÊÔµ¥ÀýÄ£Ê½
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
