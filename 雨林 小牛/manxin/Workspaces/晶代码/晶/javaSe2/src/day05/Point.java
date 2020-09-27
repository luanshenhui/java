package day05;

import java.io.Serializable;

/**
 * ���Ա����л�����
 * 
 * ���Ա����л����඼��Serializable������
 * @author Administrator
 *
 */
public class Point implements Serializable{
	/**
	 * �汾��
	 */
	private static final long serialVersionUID = 1L;
	private int x;
	/**
	 * ��transient���ε����ԣ������л�ʱ�ᱻ����
	 */
	private transient int y;
	public Point(int x, int y) {
		super();
		this.x = x;
		this.y = y;
	}
	@Override
	public String toString() {
		return "Point [x=" + x + ", y=" + y + "]";
	}
	public int getX() {
		return x;
	}
	public void setX(int x) {
		this.x = x;
	}
	public int getY() {
		return y;
	}
	public void setY(int y) {
		this.y = y;
	}
	
	
}
