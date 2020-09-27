package day01;
/**
 * Point�࣬����Object��ط���
 * Pointû����ʾ�ļ̳�Object������Ĭ�ϼ̳�
 * 
 * javadoc������Խ�һ���������е��ĵ�ע��Ӧ����
 *              ���ɸ����API�ĵ���
 * 
 * @author Administrator
 *
 */
public class Point {
	private int x;
	private int y;
	
	public Point(int x,int y){
		this.x = x;
		this.y = y;
	}
	
	@Override
	public String toString() {		
		return "x=" + x + ",y=" + y;
	}
	
	public static void main(String[] args) {
		Point p = new Point(1,2);
		/**
		 * System.out.println(Object obj)
		 * ��������ľ��Ǹ��������toString()�����ķ���ֵ
		 */
		System.out.println(p);
		
		
//		String info = p.toString();
//		/**
//		 * ���������
//		 * day01.Point@de6ced
//		 */
//		System.out.println(info);
		
		println(p);
		String s = "hello";
		println(s);
		
		/**
		 * 
		 * "=="��"equals"������
		 * "=="�Ƚ��Ƿ�Ϊͬһ������
		 * "equals"�Ƚ��������������Ƿ�һ��
		 */
		Point p1 = new Point(1,2);
		Point p2 = new Point(1,2);
		System.out.println("ͬһ������:"+(p1==p2));
		System.out.println("����һ��:"+(p1.equals(p2)));
				
	}
	
	/**
	 * ��дequals����������������ͬ�ıȽϹ���
	 */
	public boolean equals(Object obj) {
		/**
		 * ������ͬ���͵Ķ��󣬲ž��пɱ���
		 * ��ΪObject��equals�����Ĳ�������Ϊ��Object
		 * ���ԣ�����Ҫ���жϴ������Ķ����Ƿ�Ϊ
		 * ��ǰ���͵�һ��ʵ��
		 */
		if(obj instanceof Point){
			Point p = (Point)obj;
			/**
			 * ����Ƚ����ݵĹ���
			 * ���ﲻһ��Ҫ�������������������ֵ������ȫ
			 * ��ͬ��Ҫ���ʵ�ʵ�ҵ������ȥд��
			 */
			return this.x == p.x && this.y == p.y;
		}
		//����ͬһ�����͵�ʵ����û�пɱ���
		return false;
	}
	
	
	/**
	 * ���������˶�̬�ԣ�����ʹ������ͨ�á�
	 * ��̬:�������ý����������
	 * @param obj
	 */
	public static void println(Object obj){
		System.out.println(obj);
	}

	
}







