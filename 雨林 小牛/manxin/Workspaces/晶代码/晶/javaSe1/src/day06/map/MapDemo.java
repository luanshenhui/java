package day06.map;

import java.util.HashMap;
import java.util.Map;

/**
 * ��ͬ�Ķ�����Ϊkey����Map��Ч��
 * @author Administrator
 *
 */
public class MapDemo {
	public static void main(String[] args) {
		Map<Point,String> map = new HashMap<Point,String>();
		Point p = new Point(1);
		map.put(p, "��һ��");
		
		p.setX(2);
		
		map.put(p, "�ڶ���");
		map.put(p, "������");
		System.out.println(map);
		
		System.out.println(map.get(p));
		p.setX(1);
		System.out.println(map.get(p));
		
	}
}






