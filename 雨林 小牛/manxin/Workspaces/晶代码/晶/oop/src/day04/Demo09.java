package day04;

import java.util.Arrays;
/**
 * �������� 
 * 
 * ��ά���飺Java������û�ж�ά���飬��Ԫ���������һά����
 *   ��Ϊ��ά���顣�����������
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
		System.out.println(c);//Ĭ�ϵ���toString ���
		System.out.println(
				Arrays.toString(cells));//��Ҫ��дCell.toString()
	
//		Cell[] row0 = new Cell[10];//{null, null,... null}
//		Cell[] row1 = new Cell[10];
//		Cell[] row2 = new Cell[10];
//		//...
//		Cell[] row19 = new Cell[10];
		//Cell[][] wall = {row0,row1,row2, ... row19};
		Cell[][] wall=new Cell[20][10];
		wall[19][2] = new Cell(19,2);
		//��ӡǽ
		for(int i=0; i<wall.length; i++){
			//i = 0 1 2 ... 19
			System.out.println(Arrays.toString(wall[i]));
		}
	}
}
class Cell /* extends Object */{//�����ˡ�ɶ���Ƕ�����
	int row; int col;
	public Cell(int row, int col){
		this.row = row; this.col = col;
	}
	/** ��д Object �ķ��������ظ��Ӷ����ı����� */
	public String toString(){return "("+row+","+col +")";}
}




