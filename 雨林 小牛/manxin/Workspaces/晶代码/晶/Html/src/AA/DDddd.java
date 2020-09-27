package AA;

public class DDddd {
	public void test1(){
		System.out.println("a");
	}
	public static void main(String[] args) {
		DDddd d = new dd();
		d.test1();
	}
}
class dd extends DDddd{
	public void test(){
		System.out.println("b");
	}
}
