package day03.pm;
/**
 * instanceof 运算符
 *  是检查引用的对象的类型兼容性 
 *  instance 实例  of 的
 * 
 * t instance of I : 检查 t引用的对象是否是"I的实例" 
 */
public class Demo10 {
	public static void main(String[] args) {
		Tetromino t = new T();
		printType(t);
		T tx  = (T)t;// 会成功的
		//I i = (I)t;//会出现运行异常, 不安全的类型转换
		//instanceof 最常见的使用方式, 保护(安全的)类型转换
		if(t instanceof I){
			I i = (I)t;// 使用instanceof 保护的类型安全的转换
		}
	}
	public static void printType(Tetromino t){
		//t instanceof I 检查t引用的对象是否是 I 类型的
		//如果是I类型的就返回true, 否则返回false
		if(t instanceof I){
			System.out.println("I 型方块");
		}
		if(t instanceof T){
			System.out.println("T 型方块");
		}
	}
}
class Tetromino{}
class T extends Tetromino{}
class I extends Tetromino{}

