package day05.abs;

import java.util.Arrays;
/**
 * 抽象类的演示
 * 
 *语法方面：
   1）使用abstract 关键字定义抽象类
   2) 抽象类中可以定义 抽象的方法
   3）抽象类可以定义变量，引用子类型对象
   4）抽象类不能直接创建对象
   5）抽象类只能被继承
   6）继承抽象类，必须实现全部的抽象方法
   
    这个案例中 使用 abstract 限制 直接创建 Tetromino 类实例
  达到业务的合理性.  
 *
 */
public class Demo03 {
	public static void main(String[] args) {
		//直接创建 Tetromino 对象是业务逻辑不合理的!
		//Tetromino 在业务层面是抽象的概念,代表任何4格方块
		//逻辑上应该使用 abstract 定义 Tetromino 类
		//Tetromino one = new Tetromino();//编译错误
		//one.softDrop();
		//抽象类定义变量,引用具体子类的实例(对象)
		Tetromino one = new T();//new I()
		one.softDrop();
		System.out.println(Arrays.toString(one.cells)); 
		System.out.println(one.getType());//T
	}
}
class T extends Tetromino{
	public T() {
		cells[0] = new Cell(0,4);
		cells[1] = new Cell(0,3);
		cells[2] = new Cell(0,5);
		cells[3] = new Cell(1,4);
	}
	@Override
	public String getType() {
		return "T";
	}
}
class I extends Tetromino{
	public I() {
		cells[0] = new Cell(0,4);
		cells[1] = new Cell(0,3);
		cells[2] = new Cell(0,5);
		cells[3] = new Cell(0,6);
	}
	@Override
	public String getType() {
		return "I";
	}
}
/** 定义 Tetromino 是抽象类, 就不能使用 new Tetromino() */
abstract class Tetromino{
	Cell[] cells = new Cell[4];//{null,null,null,null}
	//返回 4格方块的类型(type), 是抽象方法,
	//抽象方法必须由子类实现. 子类实现抽象方法,实际上
	//是方法的重写.
	public abstract String getType();
	
	public void softDrop(){
		for(int i=0; i<cells.length; i++){
			//i = 0 1 2 3
			//cells[i] = null, null, null, null			
			cells[i].row++;
		}
	}
}

class Cell{
	int row; int col;
	public Cell(int row, int col) {
		this.row = row; this.col = col;
	}
	public String toString() {return row+","+col;}
}


