
public class F {
	
	static {
		System.out.println("静态");
	}
	
	{
		System.out.println("非静态");
	}
	
		public F(){
			System.out.println("构造方法");
		}
		public static void main(String[] args) {
			F f=new F();
		}
	}

