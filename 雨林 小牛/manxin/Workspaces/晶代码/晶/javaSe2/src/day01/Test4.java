package day01;
/*
 * �ܽ�:
����try����е�return,��ô�Ȱ�return��ֵ����ĳ������,
Ȼ��ִ��finally����Ĵ����,
����з���ֵ������䣬�͸ı���ǰ���ڳ��е��Ǹ�ֵ��
���û��,�Ͱ��Ǹ����еĶ���ȡ�������س�ȥ��

����˵����
---------�Դ�try��finally����return���������
ֻ����finally����return���Ż�ı䷵��ֵ��
����ʹ�������return��ֵ��Ҳ����ı�ԭ�е�returnֵ��
 * 
 * 
 * ����4 �� ���try��finally���Ѿ���return��
 * ���ⲿ��return���������á�
 */
public class Test4 {
	public static void main(String[] args) {
        System.out.print(tt());	
    }
	public static int tt() {
	    int b = 23;
	    try {
	        System.out.println("yes");
	        return b = 88;
	    } catch(Exception e) {
	        System.out.println("error : " + e);
	    } finally {
	        if (b > 25) {
	            System.out.println("b>25 : " + b);
	        }
	        System.out.println("finally");
	    }
	    return 100;
	}
}
