package day03;
/**
 * ���صķ����Ǹ��ݲ������͵��õ�
 * ���صķ���: ������һ��, �����б���߽в������Ͳ�ͬ�ķ���
 */
public class Demo06 {
	public static void main(String[] args) {
		Qoo q = new Qoo();
		q.test(1);//���� q.test(int)
		q.test(1L);//���� q.test(long)
		q.test('a');
	}
	public void test(char a){
		System.out.println("test(char)");
	}
}
class Qoo  extends Demo06{
	public void test(int a){
		System.out.println("test(int)");
	}
	public void test(long a){
		System.out.println("test(long)");
	}
}
