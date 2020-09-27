package day04;

import java.util.Arrays;
/**
 * 对象数组 
 * 
 * 二维数组：Java本质上没有二维数组，将元素是数组的一维数组
 *   作为二维数组。是数组的数组
 *  
 */
public class Demo09 {
	public static void main(String[] args) {
		Cell[] cells = new Cell[4];//{null, null, null, null}
		System.out.println(Arrays.toString(cells)); 
		cells[0] = new Cell(0,4);
		cells[1] = new Cell(0,3);
		cells[2] = new Cell(0,5);
		cells[3] = new Cell(1,4);
		Cell c = cells[0];
		System.out.println(c);//默认调用toString 输出
		System.out.println(
				Arrays.toString(cells));//需要重写Cell.toString()
	
//		Cell[] row0 = new Cell[10];//{null, null,... null}
//		Cell[] row1 = new Cell[10];
//		Cell[] row2 = new Cell[10];
//		//...
//		Cell[] row19 = new Cell[10];
		//Cell[][] wall = {row0,row1,row2, ... row19};
		Cell[][] wall=new Cell[20][10];
		wall[19][2] = new Cell(19,2);
		//打印墙
		for(int i=0; i<wall.length; i++){
			//i = 0 1 2 ... 19
			System.out.println(Arrays.toString(wall[i]));
		}
	}
}
class Cell /* extends Object */{//体现了“啥都是东西”
	int row; int col;
	public Cell(int row, int col){
		this.row = row; this.col = col;
	}
	/** 重写 Object 的方法，返回格子对象文本描述 */
	public String toString(){return "("+row+","+col +")";}
}




