package day05.abs;

import java.util.Arrays;
/**
 * ���������ʾ
 * 
 *�﷨���棺
   1��ʹ��abstract �ؼ��ֶ��������
   2) �������п��Զ��� ����ķ���
   3����������Զ�����������������Ͷ���
   4�������಻��ֱ�Ӵ�������
   5��������ֻ�ܱ��̳�
   6���̳г����࣬����ʵ��ȫ���ĳ��󷽷�
   
    ��������� ʹ�� abstract ���� ֱ�Ӵ��� Tetromino ��ʵ��
  �ﵽҵ��ĺ�����.  
 *
 */
public class Demo03 {
	public static void main(String[] args) {
		//ֱ�Ӵ��� Tetromino ������ҵ���߼��������!
		//Tetromino ��ҵ������ǳ���ĸ���,�����κ�4�񷽿�
		//�߼���Ӧ��ʹ�� abstract ���� Tetromino ��
		//Tetromino one = new Tetromino();//�������
		//one.softDrop();
		//�����ඨ�����,���þ��������ʵ��(����)
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
/** ���� Tetromino �ǳ�����, �Ͳ���ʹ�� new Tetromino() */
abstract class Tetromino{
	Cell[] cells = new Cell[4];//{null,null,null,null}
	//���� 4�񷽿������(type), �ǳ��󷽷�,
	//���󷽷�����������ʵ��. ����ʵ�ֳ��󷽷�,ʵ����
	//�Ƿ�������д.
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


