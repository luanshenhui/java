package day04;
/**
 * final �ķ�������������������д��
 * 1����ֹ��������д��Ҳ����ֹ��������޸�
 * 2������ʹ�ã�Ӱ�춯̬���������̳в���д���з����� 
 */
public class Demo05 {
	public static void main(String[] args) {
	}
}
class Super{
	public final void t1(){	}
	public void t2(){}
}
class Sub extends Super{
	//public void t1() {//������󣬲�����дfinal����
	//}
	public void t2() {	}
}



