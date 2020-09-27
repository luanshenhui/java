package day05;

import java.io.Serializable;

/**
 * 可以被序列化的类
 * 
 * 可以被序列化的类都是Serializable的子类
 * @author Administrator
 *
 */
public class Point implements Serializable{
	/**
	 * 版本号
	 */
	private static final long serialVersionUID = 1L;
	private int x;
	/**
	 * 被transient修饰的属性，在序列化时会被忽略
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
