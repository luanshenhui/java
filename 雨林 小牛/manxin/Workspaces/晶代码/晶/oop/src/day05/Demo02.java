package day05;
/*
 * 对象数组 是将引用类型的很多对象放到了一个数组里面
 * 那么我们以前说过 一个类型的数组只能放一种类型的数据
 */
import java.util.Arrays;

public class Demo02 {
	public static void main(String[] args) {
		//按照长度创建对象数组，每元素是null
		Cell[] line0 = new Cell[10];//[^,^,^ ... ^] 10个空
		//代表 俄罗斯方块墙上的一行
		System.out.println(Arrays.toString(line0));
		//直接给出元素，创建数组
		Cell[] cells = new Cell[]{new Cell(0,4),
				new Cell(0,3), new Cell(0,5), new Cell(1,4)};
		System.out.println(Arrays.toString(cells));  
		
		Cell[] line1 = new Cell[10];
		Cell[] line2 = new Cell[10];
		Cell[] line3 = new Cell[10];
		Cell[] line4 = new Cell[10];
		Cell[] line5 = new Cell[10];
		Cell[] line6 = new Cell[10];
		Cell[] line7 = new Cell[10];
		Cell[] line8 = new Cell[10];
		Cell[] line9 = new Cell[10];
		Cell[] line10 = new Cell[10];
		Cell[] line11 = new Cell[10];
		Cell[] line12 = new Cell[10];
		Cell[] line13 = new Cell[10];
		Cell[] line14 = new Cell[10];
		Cell[] line15 = new Cell[10];
		Cell[] line16 = new Cell[10];
		Cell[] line17 = new Cell[10];
		Cell[] line18 = new Cell[10];
		Cell[] line19 = new Cell[10];
		//一个数组被当成了一个元素
		Cell[][] wall = {line0,line1,line2,line3,line4,line5,
				line6,line7,line8,line9,line10,line11,line12,
				line13,line14,line15,line16,line17,line18,line19};
		//是一个一维数组嵌套一个一维数组
		Cell[][] wall2 = new Cell[20][10];
		
		int[][] ary2 = new int[][]{{4,5},{5,6}};
		
		int[][] ary3 = new int[][]{null,null};
		
	}
}
class Cell{
	int row; int col;
	public Cell(int row,int col){this.row=row;this.col=col;}
	public String toString() {return "("+row+","+col+")";}
}
