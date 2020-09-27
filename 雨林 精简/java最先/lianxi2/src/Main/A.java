package Main;

public class A {
	

		private String name = "张三";

		private int age = 30;

		// 类：图纸，模板。
		// 类中有类的成员变量和类的成员方法。
		// 成员变量：在类中定义的变量叫做成员变量，用来表示类的属性和状态。
		// 成员方法：在类总定义的方法叫做成员方法，用来表示类的动作和行为。
		// 构造方法：方法名和类同名，没有返回值，也不加void关键字。
		// 构造方法的作用：一是创建对象，二是初始化。
		// 构造方法注意：如果不写构造方法，系统将提供一个默认的无参的构造方法。

		public A() {

		}

		public A(int a) {

		}

		// 对象：实例，实体。

		public static void run() {
			System.out.println("跑步");
		}

		public static void eat() {
			System.out.println("吃饭");
		}

		public static void main(String[] args) {

			// 创建对象的语法格式：
			// 类的名字 变量名字 = new关键字 类的构造方法();
			A a = new A(4);
			System.out.println(a.name);
			//System.out.println(a.age);
			//a.eat();
			//a.run();

		}

	}


