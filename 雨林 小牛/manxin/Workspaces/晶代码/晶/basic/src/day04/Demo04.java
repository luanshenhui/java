package day04;
/**
 * 数组
 *  逻辑层面：类型一致的一组元素, 表示逻辑上的集合现象
 *  数据层面： 是类型一致的一组数据
 * 
 * 数组的语法： 
 *  数组变量：是引用数组的变量，是引用变量
 *  数组（数组对象）：数组整体对象
 *  数组元素：数组中每个元素
 *  
 * 羊村的全体羊，他们打败了灰太狼。
 *  他们 和 羊村的全体羊 之间是引用的关系，他们是变量
 *  他们：相当于 数组变量
 *  羊村的全体羊： 相当于 数组（数组对象）
 *  喜洋洋：数组元素
 * 
 * 1) 定义数组变量
 * 2) 创建数组（数组对象）
 * 3) 访问数组元素
 */
public class Demo04 {
	public static void main(String[] args) {
		//变量类型  变量名 = 值
		//int a = 1；
		//1) 定义数组变量
		int[] ary;//声明 int[] 数组类型的变量ary
		int ary1[];//也是声明数组变量，很少使用！
		//System.out.println(ary[0]);//编译错误，ary没有初始化
		ary = null;//null 空，没有
		System.out.println(ary[0]);
		//输出结果
		//A 编译错误  B 运行异常  C null  D 0
		
		//空指针异常发生的原因：引用类型的变量的值是null，不引用
		//任何的对象，当利用引用变量访问属性(数组元素)和方法时
		//出现空指针异常。
		
		//Object == 东西 == 对象
		//东西：什么都是东西==任何存在的事物都是东西==一切皆对象
		//对象：是个东西就是对象！
// 2) 创建数组（创建 数组对象）
		//int[] 叫变量类型 a叫变量
		int[] a = {1,2,3,4,5};
		ary = new int[3];//数组对象有3个元素
		//创建数组对象(new int[3])，将对象的引用赋值给ary变量
		//ary 就引用了数组对象，这个对象有3个元素
		System.out.println(ary[0]);//0
		System.out.println(ary[1]);
		System.out.println(ary[2]);
		//System.out.println(ary[3]);//运行异常，数组下标越界
		//Java 数组元素是自动初始化的，初始化为零值：
		// 0  0.0  \u0000  null false
		//输出结果
		//A 编译错误  B 运行异常  C null  D 0
		double[] ary3 = new double[3];
		System.out.println(ary3[0]);//0.0
		char[] chs = new char[4];
		System.out.println((int)chs[0]);//0 \u0000的编码值是0
		boolean[] used = new boolean[5];
		System.out.println(used[0]);//false
		String[] names = new String[2];
		System.out.println(names[0]);//null
	//Java 中数组有3中创建方式
		// new 类型[长度]  
		// 类型是任何类型：基本类型、类类型(String，Integer)
		// 长度：变量或常量 值：0 ~ Integer.MAX_VALUE
		ary = new int[4];//new int[0x7fffffff]
		
		//new 类型[]{元素0, 元素1, 元素2}
		//直接给出元素，元素直接初始化，元素的个数就是长度
		ary = new int[]{2,3,4};
		System.out.println(ary[0]);//2
		
		//静态初始化
		//类型[] 变量={元素0, 元素1, 元素2}
		int[] ary4 = {4,5,6};
		System.out.println(ary[0]);//4
		//可以看做是 new int[]{4,5,6} 的简化版
		//静态初始化"只能用于"声明变量同时初始化！
		//ary = {4,5,6};//编译错误
		ary = new int[]{4,5,6};//没有问题
	  
		// new int[length] 适合创建不知道具体的元素，数量很多
		// new int[]{2,3,4} 适合已经知道具体元素了，元素比较少
		// {4,5,6} 只是适合知道元素，并只能使用在声明变量直接
		// 初始化。
	
	//	3) 访问数组元素
		//数组一旦创建以后，数组的长度是不可以改变的。
		//使用.length 属性可以获取数组的长度
		//使用[下标]访问数组元素
		//数组元素范围  0 ~ length-1  共计length个元素
		//最后元素的位置: length-1
		//数组不能越界访问，会出现运行异常
		ary = new int[]{5,6,7};
		System.out.println(ary.length);//3
		ary[1]++;
		System.out.println(ary[1]);//7
		System.out.println(ary[ary.length-1]);//7
		System.out.println(ary[-1]);//运行异常！
//迭代数组元素,迭代数组,也称为遍历数组,就是逐一处理元素
		for(int i=0; i<ary.length; i++){
			// i = 0 1 ... ary.length-1 
			System.out.println(ary[i]); //
		}
	}
}


















